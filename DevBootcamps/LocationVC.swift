//
//  LocationVC
//  DevBootcamps
//
//  Created by Chris Nowak on 6/6/16.
//  Copyright © 2016 Chris Nowak Tho, LLC. All rights reserved.
//

import UIKit
import MapKit

class LocationVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // IBOutlets
    
    @IBOutlet weak var map: MKMapView!
    
    // Variables
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    var zoomRegion: MKCoordinateRegion?
    // make sure we don't drop annotations twice if returned to OUR region
    var didDropAnnotations = false
    
        // Let's pretend we downloaded these from a server
    let addresses = [
        "20433 Via San Marino Cupertino, CA 95014",
        "20650 Homestead Rd, Cupertino, CA 95014",
        "11010 N De Anza Blvd, Cupertino, CA 95014"
    ]
    
    // View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.map.delegate = self
        self.locationManager.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.locationAuthStatus()
    }
    
    // MKMapViewDelegate
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if let location = userLocation.location {
            self.centerMapOnLocation(location)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(BootcampAnnotation) {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
            annotationView.pinTintColor = UIColor.blueColor()
            annotationView.animatesDrop = true
            return annotationView
        } else if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        return nil
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        // my own customization
        // check if we finished setting OUR region, THEN drop the annotations with animation
        if self.zoomRegion != nil {
            if !self.didDropAnnotations {
                // following code taken from original spot (viewDidLoad)
                for address in self.addresses {
                    self.getPlacemarkFromAddress(address)
                }
                self.didDropAnnotations = true
            }
        }
    }
    
    // CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            self.map.showsUserLocation = true
        }
    }
    
    // Custom Helper Methods
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            self.map.showsUserLocation = true
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        self.zoomRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, self.regionRadius * 2, self.regionRadius * 2)
        self.map.setRegion(self.zoomRegion!, animated: true)
    }
    
    func createAnnotationForLocation(location: CLLocation) {
        let annotation = BootcampAnnotation(coordinate: location.coordinate)
        self.map.addAnnotation(annotation)
    }
    
    func getPlacemarkFromAddress(address: String) {
        CLGeocoder().geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: NSError?) in
            if let marks = placemarks where marks.count > 0 {
                if let location = marks[0].location {
                    // We have a valid location with coordinates
                    self.createAnnotationForLocation(location)
                }
            }
        }
    }
    
}

