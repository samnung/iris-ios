//
//  VehicleAnnotationView.swift
//  iRIS
//
//  Created by Roman Kříž on 20/11/15.
//  Copyright © 2015 Roman Kříž. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import GLKit

class VehicleAnnotation: NSObject, MKAnnotation {
    let dataItem: DataItem
    
    init(dataItem: DataItem) {
        self.dataItem = dataItem
    }
    
    // MARK: MKAnnotation
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: dataItem.lat, longitude: dataItem.lng)
    }
    
    @objc var title: String? {
        return "\(dataItem.line)"
    }
    
    @objc var subtitle: String? {
        return nil
    }
}



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


class VehicleAnnotationView: MKAnnotationView {
    var typedAnnotation: VehicleAnnotation? {
        return annotation as? VehicleAnnotation
    }
    
    var shapeView: ShapeView!
    
    override var annotation: MKAnnotation? {
        didSet {
            updateTriangle()
        }
    }
    
    required override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTriangle() {
        if shapeView == nil {
            let size = CGSize(width: 15, height: 20)

            shapeView = ShapeView()
            shapeView.fillColor = UIColor.redColor()
            shapeView.frame.size = size

            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: 0, y: 0))
            path.addLineToPoint(CGPoint(x: size.width/2, y: size.height / 4))
            path.addLineToPoint(CGPoint(x: size.width, y: 0))
            path.addLineToPoint(CGPoint(x: size.width/2, y: size.height))
            path.closePath()
            shapeView.path = path
            self.addSubview(shapeView)
        }
        
        if let annotation = typedAnnotation, let rotatation = Float(annotation.dataItem.bear) {
            shapeView.transform = CGAffineTransformMakeRotation(CGFloat(GLKMathDegreesToRadians(rotatation)))
        }
    }
}
