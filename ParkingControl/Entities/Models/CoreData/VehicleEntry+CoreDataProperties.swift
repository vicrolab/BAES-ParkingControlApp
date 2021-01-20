//
//  VehicleEntry+CoreDataProperties.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 16.01.21.
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
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var model: String?
    @NSManaged public var number: String?
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for images
extension VehicleEntry {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: VehicleEntryImage)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: VehicleEntryImage)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}

extension VehicleEntry : Identifiable {

}
