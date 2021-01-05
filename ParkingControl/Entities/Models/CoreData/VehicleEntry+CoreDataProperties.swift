//
//  VehicleEntry+CoreDataProperties.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 5.01.21.
//
//

import Foundation
import CoreData


extension VehicleEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleEntry> {
        return NSFetchRequest<VehicleEntry>(entityName: "VehicleEntry")
    }

    @NSManaged public var brand: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var location: NSObject?
    @NSManaged public var model: String?
    @NSManaged public var number: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var image: NSSet?

}

// MARK: Generated accessors for image
extension VehicleEntry {

    @objc(addImageObject:)
    @NSManaged public func addToImage(_ value: VehicleEntryImage)

    @objc(removeImageObject:)
    @NSManaged public func removeFromImage(_ value: VehicleEntryImage)

    @objc(addImage:)
    @NSManaged public func addToImage(_ values: NSSet)

    @objc(removeImage:)
    @NSManaged public func removeFromImage(_ values: NSSet)

}

extension VehicleEntry : Identifiable {

}
