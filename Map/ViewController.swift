//
//  ViewController.swift
//  Map
//
//  Created by Chinonso Obidike on 3/28/19.
//  Copyright © 2019 Chinonso Obidike. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mkMapView: MKMapView!
    
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    let geocoder: CLGeocoder = CLGeocoder()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mkMapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        assert(CLLocationManager.locationServicesEnabled())
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        let location: CLLocation = locations.last! as CLLocation
        let meters: CLLocationDistance = 100
        mkMapView.region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: meters * CLLocationDistance(mkMapView.frame.height / mkMapView.frame.width),
            longitudinalMeters: meters)
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) in
            if error != nil {
                print("geocoder error: \(error!)")
                return
            }
            
            guard let placemarks: [CLPlacemark] = placemarks else {
                fatalError("placemarks is nil")
            }
            
            for placemark in placemarks {
                print("placemark.subThoroughfare = \(placemark.subThoroughfare!)");
                print("placemark.thoroughfare = \(placemark.thoroughfare!)");
                let c: CLLocationCoordinate2D = location.coordinate
                let ns: String = c.latitude >= 0 ? "N" : "S"
                let ew: String = c.longitude >= 0 ? "E" : "W"
                print(c.longitude)
                print(c.latitude)
                
                let pointAnnotation: MKPointAnnotation = MKPointAnnotation()
                pointAnnotation.title = placemark.name
                pointAnnotation.subtitle = "\(abs(c.latitude))°\(ns) \(abs(c.longitude))°\(ew)";
                pointAnnotation.coordinate = c;
                self.mkMapView.addAnnotation(pointAnnotation);            }
        })
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            return nil;
        }
        
        let identifier: String = "Annotation";
        
        //Try to reuse an MKAnnotationView.
        if let annotationView: MKAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView.annotation = annotation;
            return annotationView;
        }
        
        //If necessary, create a new MKAnnotationView.
        let annotationView: MKAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier);
        annotationView.canShowCallout = true;   //can display info bubble
        return annotationView;
    }
    
    
}

