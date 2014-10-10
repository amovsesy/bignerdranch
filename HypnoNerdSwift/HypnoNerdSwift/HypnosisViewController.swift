//
//  HypnosisViewController.swift
//  HypnoNerdSwift
//
//  Created by Aleksandr Movsesyan on 10/8/14.
//  Copyright (c) 2014 Aleksandr Movsesyan. All rights reserved.
//

import UIKit

class HypnosisViewController : UIViewController, UITextFieldDelegate {
    override func loadView() {
        var frame = UIScreen.mainScreen().bounds
        var backgroundView = HypnosisView(frame: frame);
        
        var textFieldRect = CGRectMake(68, 70, 240, 30)
        var textField = UITextField(frame: textFieldRect)
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.placeholder = "Hypnotize me"
        textField.returnKeyType = UIReturnKeyType.Done
        textField.delegate = self
        backgroundView.addSubview(textField)
        
        self.view = backgroundView
    }
    
    override convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.tabBarItem.title = "Hypnotize"
        
        var image = UIImage(named: "Hypno.png")
        self.tabBarItem.image = image
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        drawHypnoticMessage(textField.text)
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
    
    func drawHypnoticMessage(message: String) {
        for _ in 1...20 {
            var messageLabel = UILabel()
            
            messageLabel.backgroundColor = UIColor.clearColor()
            
            var red = (CGFloat(arc4random()) % 100) / 100.0
            var grn = (CGFloat(arc4random()) % 100) / 100.0
            var blue = (CGFloat(arc4random()) % 100) / 100.0
            var alpha = (CGFloat(arc4random()) % 100) / 100.0
            messageLabel.textColor = UIColor(red: red, green: grn, blue: blue, alpha: alpha)
            messageLabel.text = message
            messageLabel.sizeToFit()
            
            var bounds = UIScreen.mainScreen().bounds
            var width = bounds.size.width - messageLabel.bounds.size.width
            var x = CGFloat(arc4random()) % width
            var height = bounds.size.height - messageLabel.bounds.size.height
            var y = CGFloat(arc4random()) % height
            
            var frame = messageLabel.frame
            frame.origin = CGPointMake(x, y)
            messageLabel.frame = frame
            
            self.view.addSubview(messageLabel)
            
            var motionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.TiltAlongHorizontalAxis)
            motionEffect.minimumRelativeValue = -25
            motionEffect.maximumRelativeValue = 25
            messageLabel.addMotionEffect(motionEffect)
            
            motionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
            motionEffect.minimumRelativeValue = -25
            motionEffect.maximumRelativeValue = 25
            messageLabel.addMotionEffect(motionEffect)
        }
    }
}