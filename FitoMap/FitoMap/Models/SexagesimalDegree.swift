//
//  SexagesimalDegree.swift
//  FitoMap
//
//  Created by Enrico Zamagni on 04/02/2020.
//  Copyright © 2020 Enrico Zamagni. All rights reserved.
//

import Foundation

struct SexagesimalDegree: Equatable {
    var dec: Int
    var minutes: Int
    var seconds: Double
    
    init(dec: Int, minutes: Int, seconds: Double) {
        self.dec = dec
        self.minutes = minutes
        self.seconds = seconds
    }
    
    init(degrees: Double) {
        let grad = floor(degrees)
        var fract = degrees - grad
        let minDec = fract * 60
        let min = floor(minDec)
        fract = minDec - min
        let sec = fract * 60
        self.init(dec: Int(grad), minutes: Int(min), seconds: sec)
    }
    
    func toString() -> String {
        return String(format: "%02d°%02d'%04.1f\"", dec, minutes, seconds)
    }
}
