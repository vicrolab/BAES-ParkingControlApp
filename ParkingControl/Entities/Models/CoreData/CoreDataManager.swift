//
//  DataBaseHelper.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 22.12.20.
//

import UIKit
import CoreData

class CoreDataManager {
   
    
    
    // singleton
    static let instance = CoreDataManager()
    
    private init() {}
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // question ???
    lazy var managedObjectContext = appDelegate.persistentContainer.viewContext
    
    
    // entity
    func entityName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)!
    }
    
    // fetched results controller for entity name
    func fetchedResultsController(entityName: String, keyForSort: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
}
