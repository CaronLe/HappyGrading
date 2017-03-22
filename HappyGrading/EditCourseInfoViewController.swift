//
//  EditCourseInfoViewController.swift
//  Happy Grading
//
//  Created by Swift on 3/14/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class EditCourseInfoViewController: UIViewController {
    // MARK: Properties
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedCourseResultsController = DataAcess.fetchData()
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var examDatePicker: UIDatePicker!
    
    var index: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let course = fetchedCourseResultsController.object(at: index!) as! Course
        nameTextField.text = course.name
        examDatePicker.date = course.examDate as! Date
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func updateCourseInfo(_ sender: UIButton)
    {
        if (nameTextField.text?.isEmpty)!
        {
            present(AlertForMissedRequiredField.singleFieldMissedAlert(nameOfField: "name"), animated: true, completion: nil)
        }
        else
        {
            let course = fetchedCourseResultsController.object(at: index!) as! Course
            course.name = nameTextField.text
            course.examDate = examDatePicker.date as NSDate?
            navigationController?.popViewController(animated: true)
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
