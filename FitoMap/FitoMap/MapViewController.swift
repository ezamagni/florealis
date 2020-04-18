//
//  MapViewController.swift
//  FitoMap
//
//  Created by Enrico Zamagni on 04/02/2020.
//  Copyright © 2020 Enrico Zamagni. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet var panelView: LocationPanelView!
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet var btnTrack: UIButton!
    
    var locationManager: LocationManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
//        locationManager = LocationManager(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager?.startTracking()
        mapView.showsUserLocation = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.userTrackingMode = .follow
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager?.stopTracking()
    }
    
    @IBAction func onButtonTrackTap(_ sender: Any) {
        trackUserLocation()
    }
    
    private func setupLocation(_ location: CLLocation) {
        mapView.updateUserLocationAnnotationView()
        let gradCoordinate = GradCoordinate(location.coordinate)
        let cfceCoordinate = CfceCoordinate(location.coordinate, precision: 2)
        panelView.setupWith(
            cfceCoordinate: cfceCoordinate,
            gpsCoordinate: location.coordinate,
            grdCoordinate: gradCoordinate)
    }
    
    private func trackUserLocation() {
        mapView.userTrackingMode = .follow
    }

}

extension MapViewController: LocationManagerDelegate {
    func locationManager(_ manager: LocationManager, didUpdateLocation location: CLLocation) {
        setupLocation(location)
    }
}

extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        guard let location = userLocation?.location else { return }
        setupLocation(location)
    }
    
    func mapView(_ mapView: MGLMapView, didChange mode: MGLUserTrackingMode, animated: Bool) {
        UIView.animate(withDuration: 0.8) {
            if mode == .none {
                self.btnTrack.alpha = 1
            } else {
                self.btnTrack.isHidden = false
                self.btnTrack.alpha = 0
            }
        }
    }
}
