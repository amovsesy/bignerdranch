//
//  ReminderViewController.swift
//  HypnoNerdSwift
//
//  Created by Aleksandr Movsesyan on 10/8/14.
//  Copyright (c) 2014 Aleksandr Movsesyan. All rights reserved.
//

import UIKit

class ReminderViewController : UIViewController {
    @IBOutlet var datePicker : UIDatePicker!
    
    @IBAction func addReminder() {
        var date = self.datePicker.date
        NSLog("Setting a reminder for %@", date)
        NSLog("Now it is %@", NSDate())
        
        var note = UILocalNotification()
        note.alertBody = "Hypnotize me!"
        note.fireDate = date
        
        UIApplication.sharedApplication().scheduleLocalNotification(note)
    }
    
    override convenience init() {
        self.init(nibName: "ReminderViewController", bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.tabBarItem.title = "Reminder"
        
        var image = UIImage(named: "Time.png")
        self.tabBarItem.image = image
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.datePicker.minimumDate = NSDate(timeIntervalSinceNow: 60)
    }
}
