//
//  GroupTabBarViewController.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/01/17.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit

class GroupTabBarViewController: UITabBarController {

    var group: GroupEntity! = nil
    var burst = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scanSingleItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "showSingleScanView:")
        let scanManyItem = UIBarButtonItem(image: UIImage(named: "AddMany"), style: UIBarButtonItemStyle.Plain, target: self, action: "showMulipleScanView:")
        navigationItem.rightBarButtonItems = [scanManyItem, scanSingleItem]        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    func showSingleScanView(sender: AnyObject!) {
        burst = false
        performSegueWithIdentifier("scanCodesSegue", sender: sender)
    }
    
    func showMulipleScanView(sender: AnyObject!) {
        burst = true
        performSegueWithIdentifier("scanCodesSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "scanCodesSegue" {
            let vc = segue.destinationViewController as! ScanBarcodeViewController
            vc.group = group
            vc.burstMode = burst
        }
    }
    

}
