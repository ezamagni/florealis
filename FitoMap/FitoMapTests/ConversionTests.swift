//
//  ConversionTests.swift
//  FitoMapTests
//
//  Created by Enrico Zamagni on 04/02/2020.
//  Copyright © 2020 Enrico Zamagni. All rights reserved.
//

import XCTest
import CoreLocation
@testable import FitoMap

class ConversionTests: XCTestCase {

    func testSexagesimalConversion() {
        XCTAssertEqual(SexagesimalDegree(degrees: 53.621).toDMSList(), [53, 37, 15])
        XCTAssertEqual(SexagesimalDegree(degrees: 42.121615).toDMSList(), [42, 7, 17])
        XCTAssertEqual(SexagesimalDegree(degrees: 12.316567).toDMSList(), [12, 18, 59])
    }

    func testCfceConversion() {
        XCTAssertEqual(CfceCoordinate(CfceCoordinate.Grid.origin), CfceCoordinate(0, 0, [1, 1]))
        
        // precision 1 tests
        XCTAssertEqual(CfceCoordinate(CLLocationCoordinate2D(latitude: 44.16388, longitude: 12.22500), precision: 1), CfceCoordinate(118, 39, [1]))
        XCTAssertEqual(CfceCoordinate(CLLocationCoordinate2D(latitude: 44.18056, longitude: 12.30833), precision: 1), CfceCoordinate(118, 39, [2]))
        XCTAssertEqual(CfceCoordinate(CLLocationCoordinate2D(latitude: 44.11667, longitude: 12.18333), precision: 1), CfceCoordinate(118, 39, [3]))
        XCTAssertEqual(CfceCoordinate(CLLocationCoordinate2D(latitude: 44.14167, longitude: 12.25833), precision: 1), CfceCoordinate(118, 39, [4]))
    
        // precision 2 test
        XCTAssertEqual(CfceCoordinate(CLLocationCoordinate2D(latitude: 44.14167, longitude: 12.25833), precision: 2), CfceCoordinate(118, 39, [4, 1]))
        XCTAssertEqual(CfceCoordinate(CLLocationCoordinate2D(latitude: 44.18056, longitude: 12.30833), precision: 2), CfceCoordinate(118, 39, [2, 2]))
        XCTAssertEqual(CfceCoordinate(CLLocationCoordinate2D(latitude: 44.11667, longitude: 12.18333), precision: 2), CfceCoordinate(118, 39, [3, 3]))
        XCTAssertEqual(CfceCoordinate(CLLocationCoordinate2D(latitude: 44.16388, longitude: 12.22500), precision: 2), CfceCoordinate(118, 39, [1, 4]))
    }
}
