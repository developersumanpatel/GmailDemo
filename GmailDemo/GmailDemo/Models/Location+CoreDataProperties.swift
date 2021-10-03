//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Suman on 25/09/21.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var city: String?
    @NSManaged public var address: String?
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double

}
