//
//  CLLocation+Extensions.swift
//  FitoMap
//
//  Created by Enrico Zamagni on 04/02/2020.
//  Copyright © 2020 Enrico Zamagni. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D {
    func toString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumIntegerDigits = 2
        formatter.minimumFractionDigits = 6
        formatter.maximumFractionDigits = 6
        let lon = formatter.string(from: NSNumber(value: longitude)) ?? ""
        let lat = formatter.string(from: NSNumber(value: latitude)) ?? ""
        return "\(lat), \(lon)"
    }
}
