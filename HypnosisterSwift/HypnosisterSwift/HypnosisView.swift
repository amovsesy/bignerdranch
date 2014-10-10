//
//  HypnosisView.swift
//  HypnosisterSwift
//
//  Created by Aleksandr Movsesyan on 10/7/14.
//  Copyright (c) 2014 Aleksandr Movsesyan. All rights reserved.
//

import UIKit

class HypnosisView : UIView {
    var circleColor = UIColor.lightGrayColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        var bounds = self.bounds
        
        var x = bounds.origin.x + bounds.size.width / 2.0
        var y = bounds.origin.y + bounds.size.height / 2.0
        var center = CGPoint(x: x, y: y)
        
        var maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0
        var path = UIBezierPath()
        
        for var radius = maxRadius; radius > 0; radius -= 20 {
            path.moveToPoint(CGPoint(x: center.x + radius, y: center.y))
            path.addArcWithCenter(center, radius: radius, startAngle: 0.0, endAngle: CGFloat(M_PI) * 2.0, clockwise: true)
        }
        
        path.lineWidth = 10
        self.circleColor.setStroke()
        path.stroke()
        
        var currentContext = UIGraphicsGetCurrentContext()
        CGContextSaveGState(currentContext)
        
        // Calculate values to use for drawing the logo
        let logoRectWidth = bounds.size.width / 2.0
        let logoRectHeight = bounds.size.height / 2.0
        let logoRectOriginX = logoRectWidth / 2.0
        let logoRectOriginY = logoRectHeight / 2.0
        
        // Draw a triangle path using the logo calculated values
        let triangleTop = CGPointMake(logoRectWidth, logoRectOriginY - 20.0)
        let triangleBottomLeft = CGPointMake(logoRectOriginX - 10.0,
            logoRectOriginY + logoRectHeight + 20.0)
        let triangleBottomRight = CGPointMake(logoRectOriginX + logoRectWidth + 10.0,
            logoRectOriginY + logoRectHeight + 20.0)
        let triangleBottomMiddle = CGPointMake(logoRectWidth,
            logoRectOriginY + logoRectHeight + 20.0)
        
        // Set "pencil" down at the top of the triangle, then draw the edges
        let trianglePath = UIBezierPath()
        trianglePath.moveToPoint(triangleTop)
        trianglePath.addLineToPoint(triangleBottomLeft)
        trianglePath.addLineToPoint(triangleBottomRight)
        trianglePath.addLineToPoint(triangleTop)
        //trianglePath.stroke()
        
        // Use the triangle path to draw a gradient
        // Gradients cover everything in the view, so a clipping path must be
        // installed on the graphics context that defines what the gradient covers
        trianglePath.addClip()
        
        // Create the gradient
        let locations: [CGFloat] = [0.0, 1.0]
        let components: [CGFloat] = [ 0.0, 1.0, 0.0, 1.0, // Start color: green
            1.0, 1.0, 0.0, 1.0] // End color: yellow
        var colorspace = CGColorSpaceCreateDeviceRGB()
        var gradient = CGGradientCreateWithColorComponents(colorspace, components,
            locations, 2)
        
        // Draw the gradient
        CGContextDrawLinearGradient(currentContext, gradient, triangleTop,
            triangleBottomMiddle, 0)
        
        // Deallocate (note: make sure gradient and colorspace are defined with
        // "var" instead of "let", or else this will give an error
        //CGGradientRelease(gradient)
        //CGColorSpaceRelease(colorspace)
        
        // Restore the graphics state to clear the clip path
        CGContextRestoreGState(currentContext)
        
        
        
        currentContext = UIGraphicsGetCurrentContext()
        CGContextSaveGState(currentContext)
        // Now anything drawn will appear with a shadow
        CGContextSetShadow(currentContext, CGSizeMake(4, 7), 3)
        
        var logoImage = UIImage(named: "logo.png")
        var logoHeight = logoImage.size.height / 2.0
        var logoWidth = logoImage.size.width / 2.0
        logoImage.drawInRect(CGRect(x: (bounds.size.width - logoWidth) / 2.0, y: (bounds.size.height - logoHeight)  / 2.0, width: logoWidth, height: logoHeight))
        
        CGContextRestoreGState(currentContext)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var red = (CGFloat(arc4random()) % 100) / 100.0
        var grn = (CGFloat(arc4random()) % 100) / 100.0
        var blue = (CGFloat(arc4random()) % 100) / 100.0
        var alpha = (CGFloat(arc4random()) % 100) / 100.0
        
        var randomColor = UIColor(red: red, green: grn, blue: blue, alpha: alpha)
        self.circleColor = randomColor
        self.setNeedsDisplay()
    }
}