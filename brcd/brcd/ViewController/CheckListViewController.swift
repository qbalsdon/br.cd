//
//  CheckListViewController.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/01/30.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit
import CoreData

class CheckListViewController: UIViewController, BarcodeScannerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var scanner: UIBarcodeScannerView!
    @IBOutlet weak var barcodeList: UITableView!
    
    var dataSource = [BarcodeEntity]()
    var scannedCodes:[BarcodeEntity:Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanner.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        if scanner != nil && scanner.previewLayer != nil {
            scanner.previewLayer.frame = CGRectMake(0, 0, view.frame.width + 5, view.frame.size.height)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        hasCamera()
        
        dataSource = fetchAllBarcodes((tabBarController as! GroupTabBarViewController).group)
        barcodeList.reloadData()
        view.bringSubviewToFront(barcodeList)
        barcodeList.alpha = 0.5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Barcode Scanning
    func failed() {
        
    }
    
    func barcodeScanned(code: String, type: String) {
        print("Scanned: \(code)")
        
        let results = dataSource.filter { elem in elem.code == code && elem.type == type }
        
        if results.count > 0 {
            scannedCodes[results[0]] = (scannedCodes[results[0]] ?? 0) + 1
        } else {
            let group = (tabBarController as! GroupTabBarViewController).group
            let nCode = NSEntityDescription.insertNewObjectForEntityForName("BarcodeEntity", inManagedObjectContext: CoreDataStackManager.sharedInstance.managedObjectContext) as? BarcodeEntity
            
            nCode?.setValue(code, forKey: BarcodeEntity.FIELD.CODE.rawValue)
            nCode?.setValue(type, forKey: BarcodeEntity.FIELD.TYPE.rawValue)
            nCode?.setValue(group, forKey: BarcodeEntity.FIELD.GROUP.rawValue)
            nCode?.setValue(1, forKey: BarcodeEntity.FIELD.QUANTITY.rawValue)
            dataSource.append(nCode!)
            CoreDataStackManager.sharedInstance.saveContext()
        }
        
        barcodeList.reloadData()
        scanner.startRunning()
    }
    
    //MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("barcodeCell", forIndexPath: indexPath)
        
        let code = dataSource[indexPath.row]
        
        let count = scannedCodes[code] ?? 0
        
        cell.textLabel!.text = "\(count) of \(code.quantity): \(getName(code))"
        
        if count == Int(code.quantity) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let deleted = dataSource[indexPath.row]
            
            CoreDataStackManager.sharedInstance.managedObjectContext.deleteObject(deleted)
            CoreDataStackManager.sharedInstance.saveContext()
            dataSource.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}
