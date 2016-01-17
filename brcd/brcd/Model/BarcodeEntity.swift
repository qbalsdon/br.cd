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
        FAVORITE = "favorite",
        NAME = "name",
        TYPE = "type",
        GROUP = "group"
    }
    
    @NSManaged var code: String
    @NSManaged var favorite: String
    @NSManaged var name: String
    @NSManaged var type: String
    @NSManaged var group: GroupEntity?
}
