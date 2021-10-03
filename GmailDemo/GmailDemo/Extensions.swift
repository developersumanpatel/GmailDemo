//
//  Extensions.swift
//  GmailDemo
//
//  Created by Suman on 25/09/21.
//

import UIKit
import CoreData
extension Notification.Name {
    static let matchesChangedNotification = Notification.Name(rawValue: "__MatchesChanged__")
}

extension NSManagedObjectContext {
    
    public func saveOrRollback() -> Bool {
        do {
            if self.hasChanges {
                try save()
                return true
            }
            return true
        } catch let error {
            rollback()
            debugPrint("----->>  Rollback Error: \(error)")
            return false
        }
    }
    
    func saveContext() {
        _ = saveOrRollback()
    }
}

extension UIViewController {
    func showAlert(title: String = "", message: String, preferredStyle: UIAlertController.Style = .alert, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
}
