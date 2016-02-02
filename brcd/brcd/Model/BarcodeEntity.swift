//
//  BarcodeEntity.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/01/17.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit
import CoreData

class BarcodeEntity: NSManagedObject {
    
    static let NAME = "BarcodeEntity"
    
    enum FIELD:String {
        case CODE = "code",
        TYPE = "type",
        GROUP = "group",
        QUANTITY = "quantity",
        PRODUCT = "product"
    }
    
    @NSManaged var code: String
    @NSManaged var type: String
    @NSManaged var quantity: Int16
    @NSManaged var group: GroupEntity?
    @NSManaged var product: ProductEntity?
}
