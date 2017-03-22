//
//  CourseManagementTableViewController.swift
//  Happy Grading
//
//  Created by Swift on 3/9/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import CoreData

class CourseManagementTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: Properties
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController = DataAcess.fetchData()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
     
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       let backgroundImageView = UIImageView.init(image: #imageLiteral(resourceName: "CourseTableViewBackGround"))
       self.tableView.backgroundView = backgroundImageView
       tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        guard let sectionCount = fetchedResultsController.sections?.count else
        {
            return 0
        }
        return sectionCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let sectionData = fetchedResultsController.sections?[section] else
        {
            return 0
        }
        return sectionData.numberOfObjects
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCellIndentifier", for: indexPath) as! CourseManagementTableViewCell
        let course = fetchedResultsController.object(at: indexPath) as! Course
        cell.nameLabel.text = course.name
        
        // Process to set total current exams
        let fetchedExams = course.mutableSetValue(forKey: "examConnect")
        let exams = fetchedExams.allObjects as! [ExamUnit]
        cell.totalTestsLabel.text = exams.count.description
        
        
        
        // Process date of Test things:
        var dateStringArray = course.examDate?.description.components(separatedBy: " ")
        if let dateStringwithYearMonthDate = dateStringArray?[0]
        {
            cell.examDateLabel.text = dateStringwithYearMonthDate
        }
       
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type
        {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch type
        {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        default: break
        }
    }


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let course = fetchedResultsController.object(at: indexPath) as! Course
            context.delete(course)
            DataAcess.saveContext()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "showExamTable", sender: indexPath)
    }
    

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
        if segue.identifier == "showExamTable"
        {
            let examTabelViewController = segue.destination as! ExamTableViewController
            let index = sender as! IndexPath
            examTabelViewController.index = index
            
            // Get name for navigationBarTitle
            let course = fetchedResultsController.object(at: index) as! Course
            examTabelViewController.navigationBarTitle = course.name
        }
    }
 

}
