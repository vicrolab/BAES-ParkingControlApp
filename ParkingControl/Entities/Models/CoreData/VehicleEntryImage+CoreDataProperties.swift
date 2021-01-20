//
//  VehicleEntryImage+CoreDataProperties.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 16.01.21.
//
//

import Foundation
import CoreData


extension VehicleEntryImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleEntryImage> {
        return NSFetchRequest<VehicleEntryImage>(entityName: "VehicleEntryImage")
    }

    @NSManaged public var data: Data?
    @NSManaged public var position: Int16
    @NSManaged public var vehicleEntry: VehicleEntry?

}

extension VehicleEntryImage : Identifiable {

}
