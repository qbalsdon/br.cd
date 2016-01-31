//
//  ExtensionUIViewController.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/01/10.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit
import CoreData
import Foundation

extension UIViewController {
    func onWebError(error: NSError!) {
        print("SOME APPROPRIATE ERROR MESSAGE")
    }
    
    func getActivityIndicator() -> UIView {        
        let loader = UILoader(frame: CGRectMake(0.0, 0.0, 100.0, 100.0))
        loader.center = view.center
        
        view.addSubview(loader)
        loader.bringSubviewToFront(view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        return loader
    }
    
    // MARK: - Link helpers
    func callNumber(number: String) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(number)")!)
    }
    
    func sendMail(email: String) {
        UIApplication.sharedApplication().openURL(NSURL(string: "mailto:\(email)")!)
    }
    
    // MARK: - Alerts
    func showMessage(title: String, message: String) {
        showMessage(title, message: message, cancelButtonText: "Ok", onComplete: nil)
    }
    
    func showMessage(title: String, message: String, cancelButtonText: String) {
        showMessage(title, message: message, cancelButtonText: cancelButtonText, onComplete: nil)
    }
    
    func showMessage(title: String, message: String, cancelButtonText: String, onComplete: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: cancelButtonText, style: UIAlertActionStyle.Default,handler: onComplete))
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    // MARK: - Data helpers
    func fetchAllGroups() -> [GroupEntity] {
        let fetchRequest = NSFetchRequest(entityName: GroupEntity.NAME)
        
        do {
            return try CoreDataStackManager.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest) as! [GroupEntity]
        } catch let error as NSError {
            print("Error fetching groups: \(error)")
            return [GroupEntity]()
        }
    }

    
    func fetchAllBarcodes() -> [BarcodeEntity] {
        let fetchRequest = NSFetchRequest(entityName: BarcodeEntity.NAME)
        
        do {
            return try CoreDataStackManager.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest) as! [BarcodeEntity]
        } catch let error as NSError {
            print("Error fetching groups: \(error)")
            return [BarcodeEntity]()
        }
    }
    
    func fetchAllBarcodes(group: GroupEntity) -> [BarcodeEntity] {
        let fetchRequest = NSFetchRequest(entityName: BarcodeEntity.NAME)
        fetchRequest.predicate = NSPredicate(format: "group = %@", group)
        do {
            return try CoreDataStackManager.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest) as! [BarcodeEntity]
        } catch let error as NSError {
            print("Error fetching groups: \(error)")
            return [BarcodeEntity]()
        }
    }
    
    func fetchBarcode(code: String, type: String) -> [BarcodeEntity] {
        let fetchRequest = NSFetchRequest(entityName: BarcodeEntity.NAME)
        let codePredicate = NSPredicate(format: "code = %@", code)
        let typePredicate = NSPredicate(format: "type = %@", type)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [codePredicate, typePredicate])
        do {
            return try CoreDataStackManager.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest) as! [BarcodeEntity]
        } catch let error as NSError {
            print("Error fetching groups: \(error)")
            return [BarcodeEntity]()
        }
    }
}
