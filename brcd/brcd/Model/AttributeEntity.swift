//
//  AttributeEntity.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/02/02.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit
import CoreData

class AttributeEntity: NSManagedObject {
    static let NAME = "AttributeEntity"
    
    enum FIELD:String {
        case NAME = "name",
        VALUE = "value",
        PRODUCT = "product"
    }
    
    @NSManaged var name: String
    @NSManaged var value: String
    @NSManaged var product: ProductEntity?
}
