//
//  DataBaseHelper.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 22.12.20.
//

import UIKit
import CoreData

class PersistentContainer {
    static let shared: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ParkingControl")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()

    private init() {}
}

class PersistentStore {
    init() {}
    
    enum VehicleEntryFetchResult {
        case success([VehicleEntry])
        case failure(Error)
    }
    
    enum VehicleEntryImageFetchResult {
        case success([VehicleEntryImage])
        case failure(Error)
    }
    
    func createVehicleEntry(brandVehicle: String, dateCreated: Date, modelVehicle: String, numberVehicle: String, photoList: [UIImage]) {
        let managedContext = PersistentContainer.shared.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "VehicleEntry", in: managedContext)!
        
        let vehicle = NSManagedObject(entity: entity, insertInto: managedContext) as! VehicleEntry
        vehicle.brand = brandVehicle
        vehicle.dateCreated = dateCreated
        vehicle.model = modelVehicle
        vehicle.number = numberVehicle
        
        for photo in photoList {
            let entity = NSEntityDescription.entity(forEntityName: "VehicleEntryImage", in: managedContext)!
            let image = NSManagedObject(entity: entity, insertInto: managedContext) as! VehicleEntryImage
            image.data = photo.pngData()

            vehicle.addToImage(image)
        }
        
        commit()
    }
    
    func fetchVehicleEntries(completion: @escaping(VehicleEntryFetchResult) -> Void) {
        let managedContext = PersistentContainer.shared.viewContext
        let fetchRequest = NSFetchRequest<VehicleEntry>(entityName: "VehicleEntry")
        
        managedContext.perform {
            do {
                let vehicleEntries = try fetchRequest.execute()
                completion(.success(vehicleEntries))
            } catch let error as NSError {
                completion(.failure(error))
                print("PersistentStore: Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func commit() {
        let context = PersistentContainer.shared.viewContext
        
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("PersistentStore: Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
