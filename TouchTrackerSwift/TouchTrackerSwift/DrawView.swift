//
//  DrawView.swift
//  TouchTrackerSwift
//
//  Created by Aleksandr Movsesyan on 10/9/14.
//  Copyright (c) 2014 Aleksandr Movsesyan. All rights reserved.
//

import UIKit

class DrawView : UIView, UIGestureRecognizerDelegate {
    var linesInProgress : Dictionary<NSValue, Line>
    var finishedLines : [Line]
    var selectedLine : Line?
    var moveRecognizer : UIPanGestureRecognizer?
    
    override init(frame: CGRect) {
        linesInProgress = Dictionary<NSValue, Line>()
        finishedLines = []
        super.init(frame: frame)
        backgroundColor = UIColor.grayColor()
        multipleTouchEnabled = true
        
        var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("doubleTap:"))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        var tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("tap:"))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        var pressRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("longPress:"))
        addGestureRecognizer(pressRecognizer)
        
        moveRecognizer = UIPanGestureRecognizer(target: self, action: Selector("moveLine:"))
        moveRecognizer?.delegate = self
        moveRecognizer?.cancelsTouchesInView = false
        addGestureRecognizer(moveRecognizer!)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func strokeLine(line: Line) {
        var bp = UIBezierPath()
        bp.lineWidth = 10
        bp.lineCapStyle = kCGLineCapRound
        bp.moveToPoint(line.begin!)
        bp.addLineToPoint(line.end!)
        bp.stroke()
    }
    
    override func drawRect(rect: CGRect) {
        UIColor.blackColor().set()
        for line in finishedLines {
            strokeLine(line)
        }
        
        UIColor.redColor().set()
        for key in linesInProgress.keys {
            strokeLine(linesInProgress[key]!)
        }
        
        if let selected = selectedLine {
            UIColor.greenColor().set()
            strokeLine(selected)
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if UIMenuController.sharedMenuController().menuVisible == true {
            return
        }
        
        for t in  touches {
            var location = t.locationInView(self)
            var line = Line()
            line.begin = location
            line.end = location
            
            var key = NSValue(nonretainedObject: t)
            linesInProgress[key] = line
        }
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for t in touches {
            var key = NSValue(nonretainedObject: t)
            var line = linesInProgress[key]
            line?.end = t.locationInView(self)
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if UIMenuController.sharedMenuController().menuVisible == true {
            return
        }
        
        for t in touches {
            var key = NSValue(nonretainedObject: t)
            var line = linesInProgress[key]
            finishedLines.append(line!)
            linesInProgress.removeValueForKey(key)
        }
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        for t in touches {
            var key = NSValue(nonretainedObject: t)
            linesInProgress.removeValueForKey(key)
        }
    }
    
    func doubleTap(gr : UIGestureRecognizer) {
        linesInProgress.removeAll(keepCapacity: false)
        finishedLines.removeAll(keepCapacity: false)
        setNeedsDisplay()
    }
    
    func tap(gr : UIGestureRecognizer) {
        var point = gr.locationInView(self)
        if let sLine = lineAtPoint(point) {
            selectedLine = sLine
            becomeFirstResponder()
            
            var menu = UIMenuController.sharedMenuController()
            var deleteItem = UIMenuItem(title: "Delete", action: Selector("deleteLine"))
            menu.menuItems = [deleteItem]
            menu.setTargetRect(CGRectMake(point.x, point.y, 2, 2), inView: self)
            menu.setMenuVisible(true, animated: true)
        } else {
            UIMenuController.sharedMenuController().setMenuVisible(false, animated: true)
            selectedLine = nil
        }
        setNeedsDisplay()
    }
    
    func longPress(gr : UIGestureRecognizer) {
        if gr.state == UIGestureRecognizerState.Began {
            var point = gr.locationInView(self)
            
            if let sLine = lineAtPoint(point) {
                selectedLine = sLine
                linesInProgress .removeAll(keepCapacity: false)
            }
        } else if gr.state == UIGestureRecognizerState.Ended {
            selectedLine = nil
        }
        
        setNeedsDisplay()
    }
    
    func lineAtPoint(p : CGPoint) -> Line? {
        for l in finishedLines {
            var start = l.begin
            var end = l.end
            
            for var t : CGFloat = 0.0; t <= 1.0; t += 0.05 {
                var x = start!.x + t * (end!.x - start!.x)
                var y = start!.y + t * (end!.y - start!.y)
                
                if hypot(x - p.x, y - p.y) < 20.0 {
                    return l
                }
            }
        }
        
        return nil
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == Selector("deleteLine") {
            return true
        }
        return false
    }
    
    func deleteLine() {
        for i in 0 ..< finishedLines.count {
            if selectedLine == finishedLines[i] {
                finishedLines.removeAtIndex(i)
                selectedLine = nil
                break
            }
        }
        
        setNeedsDisplay()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == moveRecognizer
    }
    
    func moveLine(gr : UIPanGestureRecognizer) {
        if UIMenuController.sharedMenuController().menuVisible == true {
            return
        }
        
        if let sLine = selectedLine {
            if gr.state == UIGestureRecognizerState.Changed {
                var translation = gr.translationInView(self)
                var begin = selectedLine?.begin
                var end = selectedLine?.end
                
                begin?.x += translation.x
                begin?.y += translation.y
                end?.x += translation.x
                end?.y += translation.y
                
                selectedLine?.begin = begin
                selectedLine?.end = end
                
                setNeedsDisplay()
                
                gr.setTranslation(CGPointZero, inView: self)
            }
        }
    }
}
