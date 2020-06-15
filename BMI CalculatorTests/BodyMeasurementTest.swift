//
//  BodyMeasurementTest.swift
//  BMI CalculatorTests
//
//  Created by Peter Wu on 6/14/20.
//  Copyright © 2020 Peter Wu. All rights reserved.
//

import XCTest
@testable import BMI_Calculator

class BodyMeasurementTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testBodyMeasurement() throws {
        let bodyMeasurement = BodyMeasurement(weight: Measurement(value: 150.0, unit: UnitMass.pounds), height: Measurement(value: 180.0, unit: UnitLength.centimeters))
        XCTAssertEqual(bodyMeasurement.weight.value, 150.0, "incorrect weight")
        XCTAssertEqual(bodyMeasurement.height.value, 180.0, "incorrect height")
    }

}
