//
//  BarcodeScannerDelegate.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/01/30.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit

protocol BarcodeScannerDelegate {
    func failed()
    
    func barcodeScanned(code: String, type: String)
}
