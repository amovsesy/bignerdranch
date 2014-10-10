//
//  ItemsViewController.swift
//  HomepwnerSwift
//
//  Created by Aleksandr Movsesyan on 10/8/14.
//  Copyright (c) 2014 Aleksandr Movsesyan. All rights reserved.
//

import UIKit

class ItemsViewController : UITableViewController, UITableViewDataSource {
    @IBOutlet var headerView : UIView!
    
    override init() {
        super.init(style: UITableViewStyle.Plain)
        for _ in 1...5 {
            ItemStore.sharedStore.createItem()
        }
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemStore.sharedStore.allItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
//        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "UITableViewCell")
        var item = ItemStore.sharedStore.allItems[indexPath.row]
        cell.textLabel?.text = item.description
        return cell
    }
    
    @IBAction func addNewItem() {
        
    }
    
    @IBAction func toggleEditingMode() {
        
    }
}
