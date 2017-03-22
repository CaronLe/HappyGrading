//
//  ViewController.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 11/5/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
// MARK: - ViewController: UIViewController

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController = DataAcess.fetchData()
    
    var keyboardOnScreen = false
    var isBaseExam = true
    var temperatureResultJSON: Any!
    var baseResultArray: [String] = []
    var courseIndexPath: IndexPath?
    
    // MARK: Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!

    @IBOutlet weak var phraseSearchButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var examIDLabel: UILabel!
    
    
    @IBOutlet weak var startGradingButton: UIButton!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startGradingButton.isEnabled = false
    }
    // MARK: Choose Image from library for getting base result action
    
    @IBAction func getImageFromPhotoLibrary(_ sender: AnyObject)
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        isBaseExam = true
        
        
       
    }
    
     // MARK: Choose Image from Library to Grade the exam paper within it
    @IBAction func getImageOfExamPaper(_ sender: Any)
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        isBaseExam = false
        

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        startGradingButton.isEnabled = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        else
        {
            print("something's wrong")
            return
        }
        photoImageView.image = selectedImage
        dismiss(animated: true)
        {
            () -> () in
            self.processAutoGradingTest()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute:
            {
                self.startGradingButton.isEnabled = true
            })
            
        }
        
       
    }
    
  
    // MARK: Main process
    func processAutoGradingTest()
    {
        if isBaseExam
        {
            self.postImageToAPI()

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute:
                {
                    if let temperJSON = self.temperatureResultJSON
                    {
                        self.saveJSONtoBaseResultArray(JSON: temperJSON)
                    }
                    else
                    {
                        self.resultLabel.text = "Try again"
                        self.startGradingButton.isEnabled = false
                    }
                })

        }
        else
        {
            self.postImageToAPI()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.compareResult()
            })
        }
        
        
    }

    func saveJSONtoBaseResultArray(JSON: Any)
    {
        baseResultArray = JSON as! [String]
        print(baseResultArray.count)
        temperatureResultJSON = nil
    }

    
    func compareResult()
    {
        var examArray: [String]?
        if let examArray = temperatureResultJSON as! [String]!
        {
            var count: Int = 0
            for answer in examArray
            {
                if answer == baseResultArray[examArray.index(of: answer)!]
                {
                    count += 1
                }
            }
            print(count)
            
            // Print out the result including name, score, exam ID
            let nameArray = ["Chanh Doan", "Doan Chanh", "Cason Le", "Le Doan Chanh",
                             "Chanh Le Doan"]
            let randomIndexInNameArray = Int(arc4random_uniform(UInt32(UInt(nameArray.count))))
            let randomName = nameArray[randomIndexInNameArray]
            let randomExamID = Int(arc4random_uniform(1000)) + 1000
            let s = String(repeating: " ", count: 5)
            resultLabel.text = "\(s)Result: \(count) on \(baseResultArray.count)"
            studentNameLabel.text = "\(s)Student's Name: \(randomName)"
            examIDLabel.text = "\(s)Exam's ID: \(randomExamID)"
            
            // Save Exam to Course if index was sent to this controller
            if let _ = courseIndexPath
            {
                saveExamtoCourse(score: count, examID: randomExamID)
            }
            
            // Clean JSON for the new sesson
            temperatureResultJSON = nil
        }
        
        else
        {
            resultLabel.text = "Please try again"
        }
    }
    
    
    // MARK: posting Image to API
    func postImageToAPI()
    {
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(self.photoImageView.image!, 0.5)!, withName: "imgFile", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
            
        }, to:"http://113.160.225.76:8910/process_image/api/analyze")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    //self.delegate?.showSuccessAlert()
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    if response.result.isSuccess
                    {
                        if let JSON = response.result.value
                        {
                            self.temperatureResultJSON = JSON
                        }
                        
                    }
                    else
                    {
                        self.resultLabel.text = "Image is not qualified enough"
                        
                    }
                        //                        self.showSuccesAlert()
                    //self.removeImage("frame", fileExtension: "txt")
                   
                   
                    
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                self.resultLabel.text = "Bad request or Image is not qualified enough"
                print("nice")
                print(encodingError)
                
           
            }
        
        }
        
    }
    
    func saveExamtoCourse(score: Int, examID: Int)
    {
        let fetchedCourse = fetchedResultsController.object(at: courseIndexPath!) as! Course
        let fetchedExams = fetchedCourse.mutableSetValue(forKey: "examConnect")
       
        
        if let exam = DataAcess.createRecordForEntity("ExamUnit", inManagedObjectContext: context)
        {
            exam.setValue(score, forKey: "examScore")
            exam.setValue(examID, forKey: "examId")
            fetchedExams.add(exam)
        }
        DataAcess.saveContext()
        print("save succesfully")
    }
    
    
    
}

// MARK: - ViewController: UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
        }
    }
    
    func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject)
        {
        
        }
    
    // MARK: TextField Validation
    
    func isTextFieldValid(_ textField: UITextField, forRange: (Double, Double)) -> Bool {
        if let value = Double(textField.text!), !textField.text!.isEmpty {
            return isValueInRange(value, min: forRange.0, max: forRange.1)
        } else {
            return false
        }
    }
    
    func isValueInRange(_ value: Double, min: Double, max: Double) -> Bool {
        return !(value < min || value > max)
    }
}

// MARK: - ViewController (Configure UI)


// MARK: - ViewController (Notifications)

private extension ViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
