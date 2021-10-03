//
//  AllMatchesPresenter.swift
//  GmailDemo
//
//  Created by Suman on 25/09/21.
//

import Foundation
import CoreData

protocol AllMatchesDelegate {
    func updateMatchData()
    func finishWithError(_ error: String)
}

class AllMatchesPresenter {
    var delegate: AllMatchesDelegate?
    private var dataContainter = AppDelegate.shared.persistentContainer

    init(_ delegate: AllMatchesDelegate) {
        self.delegate = delegate
    }
    
    func getAllMatches() {
        NetworkManager.shared.getAllMatches { success, result in
            if success, let result = result as? [String: Any] {
                if let response = result["response"] as? [String: Any], let venues = response["venues"] as? [[String: Any]] {
                    
                    self.dataContainter.viewContext.saveContext()
                    self.dataContainter.performBackgroundTask { (backgroundContext) in
                        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                        do {
                            try self.storeVenus(data: venues, context: backgroundContext)
                            self.delegate?.updateMatchData()
                        } catch (let error) {
                            self.delegate?.finishWithError(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    private func storeVenus(data: [[String:Any]], context: NSManagedObjectContext) throws {
        let allVeneus = fetchVenus(false)
        for obj in data {
            let filtered = allVeneus.filter{return $0.value(forKey: "venueId") as? String == obj["id"] as? String}
            if let first = filtered.first {
                first.name = obj["name"] as? String
                first.isMarkedDeleted = false
                if let location = obj["location"] as? [String:Any] {
                    first.location?.address = location["address"] as? String
                    first.location?.city = location["city"] as? String
                    first.location?.lat = location["lat"] as? Double ?? 0.0
                    first.location?.lng = location["lng"] as? Double ?? 0.0
                }
                context.saveContext()
                continue
            }
            add(obj: obj, context: context)
            context.saveContext()
        }
        
        let updateVenues = fetchVenus(false)
        for obj in updateVenues {
            let filtered = data.filter{return $0["id"] as! String == obj.value(forKey: "venueId") as! String}
            if filtered.count == 0 {
                obj.isMarkedDeleted = true
                context.saveContext()
            }
        }
    }
    
    private func add(obj: [String:Any], context: NSManagedObjectContext) {
        let result = NSEntityDescription.insertNewObject(forEntityName: "Venue", into: context) as! Venue
        result.setValue(obj["id"], forKey: "venueId")
        result.setValue(obj["name"], forKey: "name")
        result.setValue(false, forKey: "isMarkedDeleted")
        if let location = obj["location"] as? [String:Any] {
            let locationObj = NSEntityDescription.insertNewObject(forEntityName: "Location", into: context) as! Location
            locationObj.address = location["address"] as? String
            locationObj.city = location["city"] as? String
            locationObj.lat = location["lat"] as? Double ?? 0.0
            locationObj.lng = location["lng"] as? Double ?? 0.0
            result.setValue(locationObj, forKey: "location")
        }
    }
    
    private func fetchVenus(_ isSelected: Bool) -> [Venue] {
        var arr = [Venue]()
        let fetchRequest = NSFetchRequest<Venue>(entityName: "Venue")
        let mainPredicate = NSPredicate(format: "%K != %@", "isMarkedDeleted", NSNumber(value: true))
        if isSelected {
            let favouritePredicate = NSPredicate(format: "%K == %@", "isFavourite", NSNumber(value: true))
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [mainPredicate, favouritePredicate])
        } else {
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [mainPredicate])
        }
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            let context = self.dataContainter.viewContext
            arr = try context.fetch(fetchRequest)
        } catch {
            print("Failed")
        }
        return arr
    }
    
    func updateMatchesForFavourite(_ venueId: String) {
        let fetchRequest = NSFetchRequest<Venue>(entityName: "Venue")
        let mainPredicate = NSPredicate(format: "%K == %@", "venueId", venueId)
        fetchRequest.predicate = mainPredicate
        do {
            let results = try dataContainter.viewContext.fetch(fetchRequest)
            if results.count != 0 {
                results[0].setValue(!results[0].isFavourite, forKey: "isFavourite")
            }
        } catch {
            print("Fetch Failed: \(error)")
        }

        do {
            try dataContainter.viewContext.save()
           }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
        
        self.delegate?.updateMatchData()
    }
    
    func getMatchesData() -> [Venue] {
        return NetworkManager.shared.selectedMenuIndex == 0 ? fetchVenus(false) : fetchVenus(true)
    }
}
