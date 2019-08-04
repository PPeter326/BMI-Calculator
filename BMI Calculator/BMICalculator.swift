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
    
    /// Calculates BMI based on weight in kg and height in meters.
    /// Precondition: the values are within height and weight range established in NIH BMI table
    ///
    /// - Returns: BMI (Double) if weight and height data are valid.  Returns nil otherwise
    func calculateBMI(weight: Double, height: Double ) -> Double? {
        
        guard let weight = validatedWeight(weight: weight) else { return nil }
        guard let heightInMeter = validatedHeight(height: height) else { return nil }
        let BMI = weight / (heightInMeter * heightInMeter)
        return BMI
    }
        
    private func validatedWeight(weight: Double) -> Double? {
        return validWeightRangeInKgs.contains(weight) ? weight : nil
    }
    
    private func validatedHeight(height: Double) -> Double? {
        return validHeightRangeInMeters.contains(height) ? height : nil
    }
    
    // Valid weight and height ranges in lbs and inches
    private let validHeightRangeInInches = 58.0...76.0
    private let validWeightRangeInLbs = 91.0...443.0
    
    // Valid weight and height ranges in meters and kgs
    private let validHeightRangeInMeters = 1.47...1.91
    private let validWeightRangeInKgs = 41.0...201.0
    
}
