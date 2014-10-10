//
//  ItemStore.swift
//  HomepwnerSwift
//
//  Created by Aleksandr Movsesyan on 10/8/14.
//  Copyright (c) 2014 Aleksandr Movsesyan. All rights reserved.
//

import Foundation

class ItemStore {
    class var sharedStore:ItemStore {
        return globalSharedStore
    }
    
    var allItems = [Item]()
    
    func createItem() -> Item {
        var item = Item()
        self.allItems.append(item)
        return item
    }
}

let globalSharedStore = ItemStore()