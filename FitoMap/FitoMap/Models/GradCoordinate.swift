//
//  GradCoordinate.swift
//  FitoMap
//
//  Created by Enrico Zamagni on 04/02/2020.
//  Copyright © 2020 Enrico Zamagni. All rights reserved.
//

import Foundation
import CoreLocation

struct GradCoordinate: Equatable {
    var latitude: SexagesimalDegree
    var longitude: SexagesimalDegree
    
    init(latitude: SexagesimalDegree, longitude: SexagesimalDegree) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(_ location: CLLocationCoordinate2D) {
        self.init(
            latitude: SexagesimalDegree(degrees: location.latitude),
            longitude: SexagesimalDegree(degrees: location.longitude))
    }
    
    func toString() -> String {
        return latitude.toString() + "N " + longitude.toString() + "E"
    }
}
