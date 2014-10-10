//
//  CoursesViewController.swift
//  NerdfeedIpadSwift
//
//  Created by Aleksandr Movsesyan on 10/9/14.
//  Copyright (c) 2014 Aleksandr Movsesyan. All rights reserved.
//

import UIKit

class CoursesViewController : UITableViewController, UITableViewDataSource, UITableViewDelegate, NSURLSessionDataDelegate {
    var session : NSURLSession?
    var courses : NSArray?
    var webViewController : WebViewController?
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        self.navigationItem.title = "BNR Courses"
        
        var config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        fetchFeed()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = courses?.count { return count }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        var course = courses![indexPath.row] as NSDictionary
        cell.textLabel?.text = course["title"] as? String
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var course = courses![indexPath.row] as NSDictionary
        var url = NSURL.URLWithString(course["url"] as String)
        
        webViewController?.title = course["title"] as? String
        webViewController?.setURL(url)
        navigationController?.pushViewController(webViewController!, animated: true)
    }
    
    func fetchFeed () {
        var requestString = "http://bookapi.bignerdranch.com/courses.json"
        var url = NSURL(string: requestString)
        var req = NSURLRequest(URL: url)
        
        var dataTask = session?.dataTaskWithRequest(req, completionHandler: { (data, response, error) -> Void in
            if let jsonObject =  NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
                self.courses = jsonObject["courses"] as? NSArray
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        })
        
        dataTask?.resume()
    }
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
        var cred = NSURLCredential(user: "BigNerdRanch", password: "AchieveNerdvana", persistence: NSURLCredentialPersistence.ForSession)
        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, cred)
    }
}
