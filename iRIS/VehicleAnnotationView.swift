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

class VehicleAnnotationView: MKAnnotationView {
    var typedAnnotation: VehicleAnnotation? {
        return annotation as? VehicleAnnotation
    }
    
    var shapeLayer: CAShapeLayer!
    
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
        if shapeLayer == nil {
            shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = UIColor.redColor().CGColor

            let size = CGSize(width: 20, height: 20)

            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: -size.width/2, y: -size.height/2))
            path.addLineToPoint(CGPoint(x: size.width/2, y: -size.height/2))
            path.addLineToPoint(CGPoint(x: 0, y: size.height/2))
            path.closePath()
            shapeLayer.path = path.CGPath
            self.layer.addSublayer(shapeLayer)
        }
        
        if let annotation = typedAnnotation, let rotatation = Float(annotation.dataItem.bear) {
            shapeLayer.transform = CATransform3DMakeRotation(CGFloat(GLKMathDegreesToRadians(rotatation)), 0, 0, 1)
        }
    }
}
