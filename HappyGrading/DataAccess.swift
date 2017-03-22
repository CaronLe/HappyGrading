//
//  DataAccess.swift
//  PitchPerfect
//
//  Created by Swift on 03/02/2017.
//  Copyright © 2017 Swift. All rights reserved.
//

import UIKit
import CoreData

class DataAcess
{

    class func fetchData() -> NSFetchedResultsController<NSFetchRequestResult>
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Course")
        let fetchSort = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [fetchSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        //3
        do {
            try fetchedResultsController.performFetch()
            
        } catch let error as NSError {
            print("Unable to perform fetch: \(error.localizedDescription)")
        }
        return fetchedResultsController
    }
    
    class func saveContext()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do
        {
            try context.save()
        } catch let error as NSError{
            print("Error saving context after delete: \(error.localizedDescription)")
        }


    }
    
    class func createRecordForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSManagedObject? {
        
        // Helpers
        var result: NSManagedObject?
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: managedObjectContext)
        
        if let entityDescription = entityDescription {
            // Create Managed Object
            result = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)
        }
        
        return result
    }

    class func fetchDataByEntityName(nameofEntity: String) -> NSFetchedResultsController<NSFetchRequestResult>
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: nameofEntity)
        let fetchSort = NSSortDescriptor(key: "examId", ascending: false)
        fetchRequest.sortDescriptors = [fetchSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        //3
        do {
            try fetchedResultsController.performFetch()
            
        } catch let error as NSError {
            print("Unable to perform fetch: \(error.localizedDescription)")
        }
        return fetchedResultsController
    }

    
    
}
