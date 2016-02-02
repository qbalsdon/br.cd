//
//  ScanBarcodeViewController.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/01/10.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class ScanBarcodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, BarcodeScannerDelegate {
    var burstMode = false
    var group : GroupEntity? = nil
    var barcodeCapturedView: UIView? = nil
    var loader: UIView? = nil
    
    @IBOutlet weak var scannerView: UIBarcodeScannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannerView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        scannerView.previewLayer.frame = CGRectMake(0, 0, view.frame.width + 5, view.frame.size.height)
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        scannerView.startRunning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        scannerView.stopRunning()
    }
    
    func barcodeScanned(code: String, type: String) {
        let results = fetchBarcode(code, type: type)
        var barcodeEntity: BarcodeEntity? = nil
        if results.count == 0 {
            
            barcodeEntity = NSEntityDescription.insertNewObjectForEntityForName("BarcodeEntity", inManagedObjectContext: CoreDataStackManager.sharedInstance.managedObjectContext) as? BarcodeEntity
            
            barcodeEntity?.setValue(code, forKey: BarcodeEntity.FIELD.CODE.rawValue)
            barcodeEntity?.setValue(type, forKey: BarcodeEntity.FIELD.TYPE.rawValue)
            barcodeEntity?.setValue(group, forKey: BarcodeEntity.FIELD.GROUP.rawValue)
            barcodeEntity?.setValue(1, forKey: BarcodeEntity.FIELD.QUANTITY.rawValue)
        } else {
            barcodeEntity = results[0]
            let qty: Int16 = barcodeEntity!.quantity + 1
            barcodeEntity!.setValue(Int(qty), forKey: BarcodeEntity.FIELD.QUANTITY.rawValue)
        }
        
        CoreDataStackManager.sharedInstance.saveContext()
        
        if burstMode {
            barcodeCapturedView?.removeFromSuperview()
            let delay = 1.0 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            loader = getActivityIndicator()
            dispatch_after(time, dispatch_get_main_queue()) {
                self.loader?.removeFromSuperview()
                self.scannerView.startRunning()
            }
        } else {
            self.navigationController?.popViewControllerAnimated(true)            
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
}