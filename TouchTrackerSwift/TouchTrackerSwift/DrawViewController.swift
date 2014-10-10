//
//  DrawViewController.swift
//  TouchTrackerSwift
//
//  Created by Aleksandr Movsesyan on 10/9/14.
//  Copyright (c) 2014 Aleksandr Movsesyan. All rights reserved.
//

import UIKit

class DrawViewController : UIViewController {
    override func loadView() {
        view = DrawView(frame: CGRectZero)
    }
}
