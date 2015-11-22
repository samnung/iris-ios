//
//  ViewController.swift
//  iRIS
//
//  Created by Roman Kříž on 20/11/15.
//  Copyright © 2015 Roman Kříž. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        downloadAllData { result in
            switch result {
            case .Ok(let items):
                print(items.count)
                self.updateMapViewWithItems(items)
            case .Error(let error):
                print(error)
            }
        }
    }
    
    func updateMapViewWithItems(items: [DataItem]) {
        mapView.removeAnnotations(self.mapView.annotations)
        mapView.addAnnotations(items.map { VehicleAnnotation(dataItem: $0) })
    }
    
    // MARK: MKMapViewDelegate

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "vehicle"
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? VehicleAnnotationView
        if view == nil {
            view = VehicleAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        view?.frame.size = CGSize(width: 20, height: 20)
        
        return view
    }
}

