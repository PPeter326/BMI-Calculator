//
//  BMICalculator.swift
//  BMI Calculator
//
//  Created by Peter Wu on 8/4/19.
//  Copyright © 2019 Peter Wu. All rights reserved.
//

import Foundation

struct BMICalculator {
    
    // MARK: - Calculations
    
    /// Calculates BMI based on value stored in weightInLbs, heightInFt, and heightInInches
    /// if the value are within height and weight range established in NIH BMI table
    ///
    /// - Returns: BMI (Double) if weight and height data are valid.  Returns nil otherwise
    func calculateBMI(weight: Double, height: Double ) -> Double? {
        
        // validate weight data (separate) -> return validated weight data (regardless of measurement system) converted to metric system
        // validate height data (separate) -> return validated height data converted to metric system
        // calculate BMI
        
        guard let weight = validatedWeight(weight: weight) else { return nil }
        guard let heightInMeter = validatedHeight(height: height) else { return nil }
        let BMI = weight / (heightInMeter * heightInMeter)
        let roundedBMI = roundToOnewDecimal(BMI)
        return roundedBMI
    }
        
    private func validatedWeight(weight: Double) -> Double? {
        return validWeightRangeInKgs.contains(weight) ? weight : nil
    }
    
    private func validatedHeight(height: Double) -> Double? {
        return validHeightRangeInMeters.contains(height) ? height : nil
    }
    
    // Valid weight and height ranges in lbs and inches
    let validHeightRangeInInches = 58.0...76.0
    let validWeightRangeInLbs = 91.0...443.0
    
    // Valid weight and height ranges in meters and kgs
    let validHeightRangeInMeters = 1.47...1.91
    let validWeightRangeInKgs = 41.0...201.0
    
    /// This method takes a double amount and round to the nearest 1 decimal point
    ///
    /// - Parameter amount: an amount in double
    /// - Returns: amount rounded to the nearest 1 decimal point
    private func roundToOnewDecimal(_ amount: Double) -> Double {
        return round(amount * 10)/10
    }
}
