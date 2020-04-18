//
//  georefs.swift
//  geogrid
//
//  Created by Enrico Zamagni on 18/01/2020.
//  Copyright © 2020 Enrico Zamagni. All rights reserved.
//


// NW-most origin point of the CFCE grid
let CFCEOrigin = GeoJSONPosition(longitude: 17.0/3, latitude: 56)

// SE-most point of interest (in respect of Italy)
let CFCELimit = GeoJSONPosition(longitude: 18.521, latitude: 36.642)

struct GeoArea {
    let longitude: Double
    let latitude: Double
}

let CFCEBaseArea = GeoArea(
    longitude: 1.0/6,   // longitude extension of the CFCE grid (6')
    latitude: -1.0/10   // latitude extension of the CFCE grid (10')
)
