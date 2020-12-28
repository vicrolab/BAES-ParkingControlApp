//
//  Cars+CoreDataProperties.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 27.12.20.
//
//

import Foundation
import CoreData


extension Cars {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cars> {
        return NSFetchRequest<Cars>(entityName: "Cars")
    }

    @NSManaged public var brandVehicle: String?
    @NSManaged public var dateTaken: Date?
    @NSManaged public var modelVehicle: String?
    @NSManaged public var numberVehicle: String?
    @NSManaged public var photoVehicle: Data?
    @NSManaged public var placeOfInspection: NSObject?
    @NSManaged public var relationship: Images?

}

extension Cars : Identifiable {

}
