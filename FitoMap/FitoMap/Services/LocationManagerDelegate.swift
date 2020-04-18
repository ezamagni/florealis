//
//  LocationManagerDelegate.swift
//  FitoMap
//
//  Created by Enrico Zamagni on 04/02/2020.
//  Copyright © 2020 Enrico Zamagni. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: class {
    func locationManager(_ manager: LocationManager, didUpdateLocation location: CLLocation)
}
