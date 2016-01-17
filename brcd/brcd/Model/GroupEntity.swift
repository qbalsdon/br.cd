//
//  GroupEntity.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/01/17.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit
import CoreData

class GroupEntity: NSManagedObject {
    
    static let NAME = "GroupEntity"
    
    enum FIELD:String {
        case NAME = "name",
        CODES = "codes"
    }
    
    @NSManaged var name: String
    @NSManaged var codes: [BarcodeEntity]
}
