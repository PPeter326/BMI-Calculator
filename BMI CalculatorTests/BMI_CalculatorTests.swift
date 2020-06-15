//
//  BMI_CalculatorTests.swift
//  BMI CalculatorTests
//
//  Created by Peter Wu on 6/14/20.
//  Copyright © 2020 Peter Wu. All rights reserved.
//

import XCTest
@testable import BMI_Calculator

class BMI_CalculatorTests: XCTestCase {
    
    private let weightNumberFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        return formatter
    }()

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
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testBMICategory() throws {
        // test edge cases
        var BMI: Double = 18.5 // beginning of normal weight
        var category = BMICategory.category(of: BMI)
        XCTAssertEqual(category, BMICategory.normalWeight)
        
        BMI = 24.9 // end of normal weight
        category = BMICategory.category(of: BMI)
        XCTAssertEqual(category, BMICategory.normalWeight)
        
        BMI = 25 // beginning of overweight
        category = BMICategory.category(of: BMI)
        XCTAssertEqual(category, BMICategory.overWeight)
        
        BMI = 29.9 // end of overweight
        category = BMICategory.category(of: BMI)
        XCTAssertEqual(category, BMICategory.overWeight)
        
        BMI = 30.0 // beginning of obese
        category = BMICategory.category(of: BMI)
        XCTAssertEqual(category, BMICategory.obese)
    }
    
    func testBMICalculation() throws {
        let heightInInches = 70.0
        let weightInLbs = 185.9
        let BMIResult: BMIResult = BMICalculator.calculate(weight: Measurement(value: weightInLbs, unit: UnitMass.pounds), height: Measurement(value: heightInInches, unit: UnitLength.inches))
        let BMI = BMIResult.BMI.rounded()
        XCTAssertEqual(BMI, 27.0, "incorrect BMI Calculation")
        
    }
    
    func testBMICalcWithError() throws {
        // invalid height, valid weight
        var heightInInch = 37.0
        var weightInLbs = 92.0
        var (error, result) = BMICalculator.calculate(weight: Measurement(value: weightInLbs, unit: UnitMass.pounds), height: Measurement(value: heightInInch, unit: UnitLength.inches))
        
        XCTAssertNil(result, "should not have result")
        XCTAssertNotNil(error)
        
        // invalid weight, valid height
        heightInInch = 70.0
        weightInLbs = 70.0
        (error, result) = BMICalculator.calculate(weight: Measurement(value: weightInLbs, unit: UnitMass.pounds), height: Measurement(value: heightInInch, unit: UnitLength.inches))
        
        XCTAssertNil(result, "should not have result")
        XCTAssertNotNil(error)
        
        // invalid weight, invalid height
        heightInInch = 37.0
        weightInLbs = 70.0
        (error, result) = BMICalculator.calculate(weight: Measurement(value: weightInLbs, unit: UnitMass.pounds), height: Measurement(value: heightInInch, unit: UnitLength.inches))
        
        XCTAssertNil(result, "should not have result")
        XCTAssertNotNil(error)
        
        // valid weight, valid height
        heightInInch = 72.0
        weightInLbs = 150.0
        (error, result) = BMICalculator.calculate(weight: Measurement(value: weightInLbs, unit: UnitMass.pounds), height: Measurement(value: heightInInch, unit: UnitLength.inches))
        
        XCTAssertNil(error, "should not have error")
        XCTAssertNotNil(result)
        
        
    }

}
