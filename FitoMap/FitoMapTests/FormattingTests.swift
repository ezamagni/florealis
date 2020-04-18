//
//  FormattingTests.swift
//  FitoMapTests
//
//  Created by Enrico Zamagni on 04/02/2020.
//  Copyright © 2020 Enrico Zamagni. All rights reserved.
//

import XCTest
import CoreLocation

class FormattingTests: XCTestCase {

    func testCfceFormatting() {
        XCTAssertEqual(CfceCoordinate(CLLocationCoordinate2D(latitude: 44.16388, longitude: 12.22500), precision: 0).toString(), "11839")
        XCTAssertEqual(CfceCoordinate(CLLocationCoordinate2D(latitude: 44.16388, longitude: 12.22500), precision: 1).toString(), "11839/1")
        XCTAssertEqual(CfceCoordinate(CLLocationCoordinate2D(latitude: 44.14167, longitude: 12.25833), precision: 2).toString(), "11839/41")
    }
    
    func testDecFormatting() {
        XCTAssertEqual(SexagesimalDegree(degrees: 53.621).toString(), "53°37'15.6\"")
        XCTAssertEqual(SexagesimalDegree(degrees: 42.121615).toString(), "42°07'17.8\"")
        XCTAssertEqual(SexagesimalDegree(degrees: 44.016966).toString(), "44°01'01.1\"")
    }
    
    func testGradFormatting() {
        let coord = CLLocationCoordinate2D(latitude: 44.016966, longitude: 12.649554)
        XCTAssertEqual(GradCoordinate(location: coord).toString(), "44°01'01.1\"N 12°38'58.4\"E")
    }
    
    func testGpsCoordinateFormatting() {
        let coord = CLLocationCoordinate2D(latitude: 44.016966, longitude: 12.649554)
        XCTAssertEqual(coord.toString(), "44.016966, 12.649554")
    }
}
