//
//  BootcampAnnotation.swift
//  DevBootcamps
//
//  Created by Chris Nowak on 6/6/16.
//  Copyright © 2016 Chris Nowak Tho, LLC. All rights reserved.
//

import Foundation
import MapKit

class BootcampAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
