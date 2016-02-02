//
//  ProductEntity.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/02/02.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit
import CoreData

class ProductEntity: NSManagedObject {
    static let NAME = "ProductEntity"
    
    enum FIELD:String {
        case NAME = "name",
        BARCODE = "barcode"
    }
    
    @NSManaged var name: String
    @NSManaged var barcode: BarcodeEntity?
    @NSManaged var attributes: [AttributeEntity]?
}
