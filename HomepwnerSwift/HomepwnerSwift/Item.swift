//
//  Item.swift
//  HomepwnerSwift
//
//  Created by Aleksandr Movsesyan on 10/8/14.
//  Copyright (c) 2014 Aleksandr Movsesyan. All rights reserved.
//

import Foundation

class Item : NSObject {
    var itemName : String
    var serialNumber : String
    var valueInDollars : Int
    var dateCreate : NSDate
    
    override var description : String {
        get {
            return NSString(format: "%@ (%@): Worth $%d, recorded on %@", self.itemName, self.serialNumber, self.valueInDollars, self.dateCreate)
        }
    }
    
    override convenience init() {
        self.init(name: "Item")
    }
    
    init(name: String, valueInDollars: Int, serialNumber:String) {
        self.itemName = name
        self.serialNumber = serialNumber
        self.valueInDollars = valueInDollars
        self.dateCreate = NSDate()
        super.init()
    }
    
    convenience init(name: String) {
        self.init(name: name, valueInDollars: 0, serialNumber: "")
    }
}