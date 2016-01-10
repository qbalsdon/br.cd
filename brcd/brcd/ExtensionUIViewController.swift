//
//  ExtensionUIViewController.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/01/10.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit
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
    
    func callNumber(number: String) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(number)")!)
    }
    
    func sendMail(email: String) {
        UIApplication.sharedApplication().openURL(NSURL(string: "mailto:\(email)")!)
    }
    
    //MARK: Alerts
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
}
