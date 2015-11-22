//
//  ViewController.swift
//  iRIS
//
//  Created by Roman Kříž on 20/11/15.
//  Copyright © 2015 Roman Kříž. All rights reserved.
//

import UIKit
import MapKit
import GLKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        downloadNewData()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "downloadNewData", userInfo: nil, repeats: true)
    }
    
    func downloadNewData() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        downloadAllData { result in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false

            switch result {
            case .Ok(let items):
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
    
    func updateAllVisibleAnnotationsDirections() {
        let mapHeading = mapView.camera.heading
        
        mapView.annotationsInMapRect(mapView.visibleMapRect).forEach { annotation in
            guard let annotation = annotation as? VehicleAnnotation else {
                return
            }
            guard let view = mapView.viewForAnnotation(annotation) as? VehicleAnnotationView else {
                return
            }
            
            view.setMapHeading(mapHeading, animated: true)
        }
    }
    
    // MARK: MKMapViewDelegate

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "vehicle"
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? VehicleAnnotationView
        if view == nil {
            view = VehicleAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        view?.frame.size = VehicleAnnotationView.arrowSize
        view?.canShowCallout = true
        
        return view
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateAllVisibleAnnotationsDirections()
    }
}

