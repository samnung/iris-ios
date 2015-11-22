//
//  CGRect+Extensions.swift
//  iRIS
//
//  Created by Roman Kříž on 22/11/15.
//  Copyright © 2015 Roman Kříž. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGRect {
    var mid: CGPoint {
        return CGPoint(x: CGRectGetMidX(self), y: CGRectGetMidY(self))
    }
}