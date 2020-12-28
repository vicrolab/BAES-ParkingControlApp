//
//  Images+CoreDataProperties.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 27.12.20.
//
//

import Foundation
import CoreData


extension Images {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Images> {
        return NSFetchRequest<Images>(entityName: "Images")
    }

    @NSManaged public var imageView: Data?
    @NSManaged public var relationship: NSSet?

}

// MARK: Generated accessors for relationship
extension Images {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: Cars)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: Cars)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)

}

extension Images : Identifiable {

}
