//
//  BarcodeDataViewController.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/02/02.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit

class BarcodeDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var barcode: BarcodeEntity! = nil
    
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var barcodeImage: UIImageView!
    @IBOutlet weak var attributesTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //findData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func findData() {
        OutpanAPI.sharedInstance.getProduct(barcode.code, onSuccess: {product in
            product.setValue(self.barcode, forKey: ProductEntity.FIELD.BARCODE.rawValue)
            CoreDataStackManager.sharedInstance.saveContext()
            self.attributesTable.reloadData()
            }, onError: {one, two in
                print("Error: \(one) \(two)")
        })
    }
    
    //MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let attrs = barcode.product?.attributes {
            return attrs.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("attributeCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = barcode.product?.attributes![indexPath.row].value
        cell.detailTextLabel!.text = barcode.product?.attributes![indexPath.row].name
        
        cell.accessoryType = UITableViewCellAccessoryType.DetailButton
        
        return cell
    }
    
    //MARK: - Events
    
    @IBAction func cancelPressed(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
