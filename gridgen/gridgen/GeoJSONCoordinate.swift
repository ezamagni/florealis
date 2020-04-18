//
//  GeoJSONCoordinate.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import Foundation

/// The fundamental geometry construct.
public struct GeoJSONPosition: Equatable {
    /// The longitudinal coordinate.
    public let longitude: Double
    /// The latitudinal coordinate.
    public let latitude: Double
    /// The elevation at the coordinates.
    public let elevation: Double?

    /// Create a new `GeoJSONPosition`
    ///
    /// - Parameters:
    ///   - longitude: The longitudinal coordinate.
    ///   - latitude: The latitudinal coordinate.
    ///   - elevation: The elevation at the coordinates.
    public init(longitude: Double, latitude: Double, elevation: Double? = nil) {
        self.longitude = longitude
        self.latitude = latitude
        self.elevation = elevation
    }
}

// MARK: - Codable

let numFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 6
    return formatter
}()

extension GeoJSONPosition: Codable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        longitude = Double(truncating: try container.decode(Decimal.self) as NSNumber)
        latitude = Double(truncating: try container.decode(Decimal.self) as NSNumber)
        if let elev = try container.decodeIfPresent(Decimal.self) {
            elevation = Double(truncating: elev as NSNumber)
        } else {
            elevation = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(Decimal(longitude))
        try container.encode(Decimal(latitude))
        if let elevation = elevation {
            try container.encode(Decimal(elevation))
        }
    }
}
