//
//  ShapeView.swift
//  iRIS
//
//  Created by Roman Kříž on 22/11/15.
//  Copyright © 2015 Roman Kříž. All rights reserved.
//

import UIKit


class ShapeView: UIView {
    override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
    
    var typedLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }
    
    var path: UIBezierPath? {
        set {
            typedLayer.path = newValue?.CGPath
        }
        get {
            return typedLayer.path.flatMap { UIBezierPath(CGPath: $0) }
        }
    }
    
    var fillColor: UIColor? {
        set {
            typedLayer.fillColor = newValue?.CGColor
        }
        get {
            return typedLayer.fillColor.flatMap { UIColor(CGColor: $0) }
        }
    }
}
