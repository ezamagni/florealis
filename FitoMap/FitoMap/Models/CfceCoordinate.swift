//
//  CfceCoordinate.swift
//  FitoMap
//
//  Created by Enrico Zamagni on 04/02/2020.
//  Copyright © 2020 Enrico Zamagni. All rights reserved.
//

import Foundation
import CoreLocation

struct CfceCoordinate: Equatable {
    // grid
    let latitude: Int
    let longitude: Int
    
    // quads
    let quads: [Int]
    
    init(_ latitude: Int, _ longitude: Int, _ quads: [Int] = []) {
        self.latitude = latitude
        self.longitude = longitude
        self.quads = quads
    }
    
    init(_ coordinate: CLLocationCoordinate2D, precision: Int = 2) {
        assert(precision >= 0)

        let refPoint = CLLocationCoordinate2D(
            latitude: Grid.origin.latitude - coordinate.latitude,
            longitude: coordinate.longitude - Grid.origin.longitude)
        let latDec = refPoint.latitude / Grid.size.latitude;
        let lonDec = refPoint.longitude / Grid.size.longitude;

        let quads = (0 ..< precision)
            .map({ CfceCoordinate.quandrantOf(lat: latDec, lon: lonDec, level: $0 + 1) })
        self.init(Int(floor(latDec)), Int(floor(lonDec)), quads)
    }
    
    private static func quandrantOf(lat: Double, lon: Double, level: Int) -> Int {
        assert(level >= 1)
        let div = pow(0.5, Double(level - 1))
        let latr = lat.truncatingRemainder(dividingBy: div)
        let lonr = lon.truncatingRemainder(dividingBy: div)
        return (latr < div / 2 ? 1 : 3)
            + (lonr < div / 2 ? 0 : 1)
    }
    
    func toString() -> String {
        var description = "\(latitude)\(longitude)"
        if !quads.isEmpty {
            description += "/" + quads.map(String.init).joined()
        }
        return description
    }
}

extension CfceCoordinate {
    struct Grid {
        private init() {}
        
        static var origin = CLLocationCoordinate2D(latitude: 56, longitude: 17.0/3.0)
        static var size = (latitude: 0.1, longitude: 1.0/6.0)
    }
}
