//
//  BarcodeDataViewController.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/02/02.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit
import CoreData
import RSBarcodes_Swift

class BarcodeDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var barcode: BarcodeEntity! = nil
    var currentAttribute: String = ""
    
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var barcodeImage: UIImageView!
    @IBOutlet weak var attributesTable: UITableView!
    
    
    @IBOutlet var attributeNameField: UITextField!
    @IBOutlet var attributeValueField: UITextField!
    
    var loader: UIView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshName()
        barcodeImage.image = generateCode(barcode)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshName() {
        barcodeLabel.text = getName(barcode)
    }
    
    func generateCode(barcode: BarcodeEntity) -> UIImage? {
        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcode.code, machineReadableCodeObjectType: barcode.type) {
            return RSAbstractCodeGenerator.resizeImage(image, scale: 3.0)
        }
        return nil
    }
    
    func findData() {
        loader = getActivityIndicator()
        OutpanAPI.sharedInstance.getProduct(barcode.code, onSuccess: {product in
            self.loader.removeFromSuperview()
            product.setValue(self.barcode, forKey: ProductEntity.FIELD.BARCODE.rawValue)
            CoreDataStackManager.sharedInstance.saveContext()
            self.attributesTable.reloadData()
            }, onError: {message, details in
                self.loader.removeFromSuperview()
                self.showMessage("Error", message: message, cancelButtonText: "Cancel", actionButton: "Add new", actionEvent: { _ in
                    self.addNewProduct()
                })
        })
    }

    func addNewProduct() {
        let newProdPrompt = UIAlertController(title: "Name", message: "Enter the name for '\(barcode.code)'", preferredStyle: UIAlertControllerStyle.Alert)
        newProdPrompt.addTextFieldWithConfigurationHandler(addNameField)
        newProdPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        newProdPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: productNameEntered))
        
        presentViewController(newProdPrompt, animated: true, completion: nil)
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
        
        return cell
    }
    
    //MARK: - Info retrieval
    func addNameField(textField: UITextField!){
        textField.placeholder = "New product name"
        textField.autocapitalizationType = UITextAutocapitalizationType.Sentences
        attributeNameField = textField
    }
    
    func addAttributeNameField(textField: UITextField!){
        textField.placeholder = "New attribute name"
        textField.autocapitalizationType = UITextAutocapitalizationType.Sentences
        attributeNameField = textField
    }
    
    func addAttributeValueField(textField: UITextField!){
        textField.placeholder = "\(currentAttribute) value"
        textField.autocapitalizationType = UITextAutocapitalizationType.Sentences
        attributeValueField = textField
    }

    func productNameEntered(alert: UIAlertAction!){
        let name = attributeNameField.text!
        OutpanAPI.sharedInstance.saveProductName(barcode.code, name: name, onSuccess: {
            product in
            product.setValue(self.barcode, forKey: ProductEntity.FIELD.BARCODE.rawValue)
            CoreDataStackManager.sharedInstance.saveContext()
            self.attributesTable.reloadData()
            self.refreshName()
            
            }, onError: {message, detail in
                self.showMessage("Error", message: message)
        })
    }
    
    func attributeNameEntered(alert: UIAlertAction!){
        currentAttribute = attributeNameField.text!
        let newAttPrompt = UIAlertController(title: "Value for \(currentAttribute)", message: "Enter the value for '\(currentAttribute)'", preferredStyle: UIAlertControllerStyle.Alert)
        newAttPrompt.addTextFieldWithConfigurationHandler(addAttributeValueField)
        newAttPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        newAttPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: attributeValueEntered))
        presentViewController(newAttPrompt, animated: true, completion: nil)
    }
    
    func attributeValueEntered(alert: UIAlertAction!){
        let value = attributeValueField.text!
        
        let attribute = NSEntityDescription.insertNewObjectForEntityForName("AttributeEntity", inManagedObjectContext: CoreDataStackManager.sharedInstance.managedObjectContext) as? AttributeEntity
        attribute?.setValue(currentAttribute, forKey: AttributeEntity.FIELD.NAME.rawValue)
        attribute?.setValue(value, forKey: AttributeEntity.FIELD.VALUE.rawValue)
        attribute?.setValue(barcode.product, forKey: AttributeEntity.FIELD.PRODUCT.rawValue)
        
        loader = getActivityIndicator()
        OutpanAPI.sharedInstance.saveProductAttribute(barcode.code, attributeName: currentAttribute, attributeValue: value, onSuccess: addedSuccess, onError: { message, _ in
                self.loader.removeFromSuperview()
                self.showMessage("Error", message: message)
            })
    }
    
    func addedSuccess() {
        loader.removeFromSuperview()
        CoreDataStackManager.sharedInstance.saveContext()
        attributesTable.reloadData()
    }
    
    //MARK: - Events
    
    @IBAction func cancelPressed(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addAttributePressed(sender: AnyObject) {
        if barcode.product == nil {
            showMessage("Error", message: "You need to search for the product first")
            return
        }
        
        let newAttPrompt = UIAlertController(title: "New Attribute", message: "Enter the name of the new attribute", preferredStyle: UIAlertControllerStyle.Alert)
        newAttPrompt.addTextFieldWithConfigurationHandler(addAttributeNameField)
        newAttPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        newAttPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: attributeNameEntered))
        presentViewController(newAttPrompt, animated: true, completion: nil)
    }
    
    @IBAction func searchForData(sender: AnyObject) {
        findData()
    }
    
}
