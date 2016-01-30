//
//  CheckListViewController.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/01/30.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit

class CheckListViewController: UIViewController, BarcodeScannerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var scanner: UIBarcodeScannerView!
    @IBOutlet weak var barcodeList: UITableView!
    
    var dataSource = [BarcodeEntity]()
    var scannedCodes:[String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scanner.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        dataSource = fetchAllBarcodes()
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
        scannedCodes[code] = type
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
        
        cell.textLabel!.text = "\(code.name) [\(code.code)]"
        
        if let _ = scannedCodes[code.code] {
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
