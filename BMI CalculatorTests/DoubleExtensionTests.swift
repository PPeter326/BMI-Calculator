//
//  BMI_CalculatorTests.swift
//  BMI CalculatorTests
//
//  Created by Peter Wu on 8/2/19.
//  Copyright © 2019 Peter Wu. All rights reserved.
//

import XCTest
//@testable import BMI_Calculator

class DoubleExtensionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPoundToKg() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let weightInLb: Double = 100.00
        let weightInKg = weightInLb.lbToKg
        let poundToKgConstant = 0.453592
        
        XCTAssertEqual(weightInKg, weightInLb * poundToKgConstant, "KG weight not converted correctly")
        
    }
    
    func testInchToMeter() {
        let heightInInches: Double = 72
        let heightInMeter = heightInInches.inchToMeter
        let inchToMeterConstant = 0.0254
        
        XCTAssertEqual(heightInMeter, heightInInches * inchToMeterConstant, "Height meter not converted correctly")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
