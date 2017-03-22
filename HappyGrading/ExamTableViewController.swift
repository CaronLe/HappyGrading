//
//  ExamTableViewController.swift
//  Happy Grading
//
//  Created by Swift on 3/13/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import CoreData

class ExamTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    // MARK: Properties
    var index: IndexPath?
    var navigationBarTitle: String?

    @IBOutlet var navigationTitle: UINavigationItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController = DataAcess.fetchData()
    
    var course: Course?
    var exams = [ExamUnit]()
    
    @IBOutlet weak var gradingTestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle.title = "\(navigationBarTitle!)'s Exam"
        // check if the course has not had any graded exam
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute:
            {
                if self.exams.count == 0
                {
                    self.gradingTestButton.setTitle("Start Grading", for: .normal)
                }

        })

                // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
        
        
        let backgroundImageView = UIImageView.init(image: #imageLiteral(resourceName: "CourseTableViewBackGround"))
        self.tableView.backgroundView = backgroundImageView
        
        let fetchedCourse = fetchedResultsController.object(at: index!) as! Course
        let fetchedExams = fetchedCourse.mutableSetValue(forKey: "examConnect")

        
        course = fetchedCourse
        exams = fetchedExams.allObjects as! [ExamUnit]
        print(exams.count)
       
//        for index in 1...5
//        {
//            if let exam = DataAcess.createRecordForEntity("ExamUnit", inManagedObjectContext: context)
//            {
//                exam.setValue(25287 + index, forKey: "examId")
//                exam.setValue(arc4random_uniform(25) + 5, forKey: "examScore")
//                fetchedExams.add(exam)
//            }
//        }
//        DataAcess.saveContext()
        
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Check \(exams.count)")
        // #warning Incomplete implementation, return the number of rows
       return exams.count
       
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "examCellIdentifier", for: indexPath) as! ExamTableViewCell
        cell.idLabel.text = exams[indexPath.item].examId.description
        cell.scoreLabel.text = exams[indexPath.item].examScore.description

        return cell
    }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            let fetchedExamsResultController = DataAcess.fetchDataByEntityName(nameofEntity: "ExamUnit")
//            fetchedExamsResultController.delegate = self
//            let exam = fetchedExamsResultController.object(at: indexPath) as! ExamUnit
            
            let exam = exams[indexPath.item]
            context.delete(exam)
            DataAcess.saveContext()
            tableView.reloadData()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    // MARK: Function of FetchedResultsController
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        switch type
//        {
//        case .insert:
//            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
//        case .delete:
//            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
//        default:
//            break
//        }
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
//    {
//        switch type
//        {
//        case .insert:
//            tableView.insertRows(at: [newIndexPath!], with: .automatic)
//        case .delete:
//            tableView.deleteRows(at: [indexPath!], with: .automatic)
//        default: break
//        }
//    }

    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "editCourseInfoSegue"
        {
            
            let editCourseInfoViewController = segue.destination as! EditCourseInfoViewController
            editCourseInfoViewController.index = index
            
        }
        
        if segue.identifier == "continueGradingSegue"
        {
            let gradingProcessViewController = segue.destination as! ViewController
            gradingProcessViewController.courseIndexPath = index
        }
    }
   

}
