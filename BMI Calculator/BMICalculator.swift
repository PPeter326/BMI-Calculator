//
//  BMICalculator.swift
//  BMI Calculator
//
//  Created by Peter Wu on 8/4/19.
//  Copyright © 2019 Peter Wu. All rights reserved.
//

import Foundation

struct BMICalculator {
    
    /// Calculates BMI based on weight in kg and height in meters.  The formula is BMI = kg / m^2
    /// Precondition: the values are within height and weight range established in NIH BMI table
    ///
    /// - Parameters:
    ///   - weight: in kilograms
    ///   - height: in meters
    /// - Returns: BMI (Double) if weight and height data are valid.  Returns nil otherwise
    func calculateBMI(weight: Measurement<UnitMass>, height: Measurement<UnitLength> ) -> Double? {
        
        guard let weight = validatedWeight(weight: weight)?.converted(to: UnitMass.kilograms) else { return nil }
        guard let heightInMeter = validatedHeight(height: height)?.converted(to: UnitLength.meters) else { return nil }
        let BMI = weight.value / (heightInMeter.value * heightInMeter.value)
        return BMI
    }
        
    private func validatedWeight(weight: Measurement<UnitMass>) -> Measurement<UnitMass>? {
        return validWeightRangeInLbs.contains(weight.converted(to: UnitMass.pounds).value) ? weight : nil
    }
    
    private func validatedHeight(height: Measurement<UnitLength>) -> Measurement<UnitLength>? {
        return validHeightRangeInInches.contains(height.converted(to: UnitLength.inches).value) ? height : nil
    }
    
    /// Valid height ranges in inches
    /// based on *Clinical Guidelines on the Identification, Evaluation, and Treatment of Overweight and Obesity in Adults: The Evidence Report.*
    private let validHeightRangeInInches = 58.0...76.0
    /// Valid weight height ranges in lbs
    /// based on *Clinical Guidelines on the Identification, Evaluation, and Treatment of Overweight and Obesity in Adults: The Evidence Report.*
    private let validWeightRangeInLbs = 91.0...443.0
}
