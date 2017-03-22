//
//  AddNewCourseViewController.swift
//  Happy Grading
//
//  Created by Swift on 3/10/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import CoreData

class AddNewCourseViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var courseNameTextField: UITextField!
    @IBOutlet weak var dateOfTest: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func addNewCourseAction(_ sender: UIButton)
    
    {
        if (courseNameTextField.text?.isEmpty)!
        {
            present(AlertForMissedRequiredField.singleFieldMissedAlert(nameOfField: "name"), animated: true, completion: nil)
            
        }
            
            //  Else: save new Course
        else
        {
            let entityDescription = NSEntityDescription.entity(forEntityName: "Course", in: context)
            
            let course = Course(entity: entityDescription!, insertInto: context)
            
            course.name = courseNameTextField.text
            course.examDate = dateOfTest.date as NSDate?
            course.totalExams = 0
            
            
            do
            {
                try context.save()
                print("saved successfully!")
                self.navigationController?.popViewController(animated: true)
                print(course.examDate)
            }
            catch let error as NSError {
                print("Could not save \(error)")
                
            }
            
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
