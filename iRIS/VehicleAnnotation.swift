//
//  VehicleAnnotation.swift
//  iRIS
//
//  Created by Roman Kříž on 22/11/15.
//  Copyright © 2015 Roman Kříž. All rights reserved.
//

import MapKit

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
