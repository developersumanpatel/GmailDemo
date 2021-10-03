//
//  Venue+CoreDataProperties.swift
//  
//
//  Created by Suman on 25/09/21.
//
//

import Foundation
import CoreData


extension Venue {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Venue> {
        return NSFetchRequest<Venue>(entityName: "Venue")
    }

    @NSManaged public var venueId: String?
    @NSManaged public var name: String?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var location: Location?
    @NSManaged public var isMarkedDeleted: Bool

}
