//
//  main.swift
//  geogrid
//
//  Created by Enrico Zamagni on 18/01/2020.
//  Copyright © 2020 Enrico Zamagni. All rights reserved.
//

import Foundation

typealias StringProperties = Dictionary<String, String>


print("Preparing GeoJSON")

let idFormatter = NumberFormatter()
idFormatter.numberStyle = .none
idFormatter.minimumIntegerDigits = 5

let latStride = stride(from: CFCEOrigin.latitude,
                       through: CFCELimit.latitude,
                       by: CFCEBaseArea.latitude)
let lonStride = stride(from: CFCEOrigin.longitude,
                       through: CFCELimit.longitude,
                       by: CFCEBaseArea.longitude)

let gridFeatures =
    latStride.flatMap { (lat) -> [GeoJSON.Feature] in
        lonStride.map { (lon) -> GeoJSON.Feature in
//            let id = idFormatter.string(from: NSNumber(integerLiteral: ilon + ilat * 100))!
            return GeoJSON.Feature(
                type: "Feature",
                geometry: .polygon(coordinates: [[
                        GeoJSONPosition(longitude: lon, latitude: lat + CFCEBaseArea.latitude),
                        GeoJSONPosition(longitude: lon, latitude: lat),
                        GeoJSONPosition(longitude: lon + CFCEBaseArea.longitude, latitude: lat),
                        GeoJSONPosition(longitude: lon + CFCEBaseArea.longitude, latitude: lat + CFCEBaseArea.latitude),
                        GeoJSONPosition(longitude: lon, latitude: lat + CFCEBaseArea.latitude),
                    ]]),
                properties: [:],
                id: nil //.string(value: id)
            )
    }
}

let latLines =
    latStride.map { (lat) -> GeoJSON.Feature in
        return GeoJSON.Feature(
            type: "Feature",
            geometry: .lineString(coordinates: [
                GeoJSONPosition(longitude: CFCEOrigin.longitude, latitude: lat + CFCEBaseArea.latitude / 2),
                GeoJSONPosition(longitude: CFCELimit.longitude, latitude: lat + CFCEBaseArea.latitude / 2),
            ]),
            properties: [:],
            id: nil
        )
}

let lonLines =
    lonStride.map { (lon) -> GeoJSON.Feature in
        return GeoJSON.Feature(
            type: "Feature",
            geometry: .lineString(coordinates: [
                GeoJSONPosition(longitude: lon + CFCEBaseArea.longitude / 2, latitude: CFCEOrigin.latitude),
                GeoJSONPosition(longitude: lon + CFCEBaseArea.longitude / 2, latitude: CFCELimit.latitude),
            ]),
            properties: [:],
            id: nil
        )
}

let collection = GeoJSON.FeatureCollection(features: gridFeatures + latLines + lonLines)

do {
    print("Encoding GeoJSON")
    let jsonData = try JSONEncoder().encode(GeoJSON.featureCollection(featureCollection: collection, boundingBox: nil))
    print("Writing GeoJSON")
    try jsonData.write(to: URL(fileURLWithPath: "grid.geojson"))
} catch (let e) {
    print("Error: \(e.localizedDescription)")
}

print("Done")
