//
//  LocationManager.swift
//  FitoMap
//
//  Created by Enrico Zamagni on 04/02/2020.
//  Copyright © 2020 Enrico Zamagni. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    weak var delegate: LocationManagerDelegate?
    var lastLocation: CLLocation?
    
    private var locationManager = CLLocationManager()
    private var canStartTracking = false
    private var shouldStartTracking = false
    
    
    init(delegate: LocationManagerDelegate? = nil) {
        super.init()
        self.delegate = delegate
        locationManager.delegate = self
    }
    
    func startTracking() {
        shouldStartTracking = true
        if (canStartTracking) {
            locationManager.startUpdatingLocation()
            lastLocation = nil
        }
    }
    
    func stopTracking() {
        shouldStartTracking = false
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let validLocations = locations.filter({ $0.horizontalAccuracy < 20 })
        guard let location = validLocations.last else {
            return
        }
        
        lastLocation = location
        delegate?.locationManager(self, didUpdateLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        canStartTracking = [
            CLAuthorizationStatus.authorizedAlways,
            CLAuthorizationStatus.authorizedWhenInUse
        ].contains(status)
        if (canStartTracking && shouldStartTracking) {
            startTracking()
        } else if (status == .notDetermined) {
            manager.requestWhenInUseAuthorization()
        }
    }
}
