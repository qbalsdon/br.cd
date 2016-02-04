//
//  BarcodeListTableViewController.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/01/17.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit
import CoreData

class BarcodeListTableViewController: UITableViewController {

    @IBOutlet var barcodeList: UITableView!
    
    var dataSource = [BarcodeEntity]()
    var currentBarcode: BarcodeEntity! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(animated: Bool) {
        dataSource = fetchAllBarcodes((tabBarController as! GroupTabBarViewController).group)
        barcodeList.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("barcodeCell", forIndexPath: indexPath)

        let code = dataSource[indexPath.row]
        
        cell.textLabel!.text = "\(getName(code)) x \(code.quantity)"

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let deleted = dataSource[indexPath.row]
            
            CoreDataStackManager.sharedInstance.managedObjectContext.deleteObject(deleted)
            CoreDataStackManager.sharedInstance.saveContext()
            dataSource.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentBarcode = dataSource[indexPath.row]
        performSegueWithIdentifier("showEditBarcodeSegue", sender: self)
    }
    
    //MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let nc = segue.destinationViewController as! UINavigationController
        let vc = nc.viewControllers[0] as! BarcodeDataViewController
        
        vc.barcode = currentBarcode
    }
}
