//
//  UserData.swift
//  BMI Calculator
//
//  Created by Peter Wu on 11/14/18.
//  Copyright © 2018 Peter Wu. All rights reserved.
//

import Foundation

struct UserInput: Codable {
    
    var weightInLbs: Double
    var heightInInches: Double
    var BMI: Double? {
        return calculateBMI()
    }
    
    init(weightInLbs: Double, heightInInches: Double) {
        self.weightInLbs = weightInLbs
        self.heightInInches = heightInInches
    }
    
    /// Calculates BMI based on value stored in weightInLbs, heightInFt, and heightInInches
    /// if the value are within height and weight range established in NIH BMI table
    ///
    /// - Returns: BMI (Double) if weight and height data are valid.  Returns nil otherwise
    func calculateBMI() -> Double? {
        
        // Validate weight and height data
        if validHeightAndWeight() {
            let heightInMeter = heightInInches.inchToMeter
            let weightInKg = weightInLbs.lbToKg
            let BMI = weightInKg / (heightInMeter * heightInMeter)
            let roundedBMI = roundToOnewDecimal(BMI)
            return roundedBMI
        } else {
            return nil
        }
        
    }
    
    func validHeightAndWeight() -> Bool {
        
        // Check weight and height to make sure it's within valid range
        let validHeightRangeInInches = 58.0...76.0
        let validWeightRangeInLbs = 91.0...443.0
        
        return validWeightRangeInLbs.contains(weightInLbs) && validHeightRangeInInches.contains(heightInInches) ? true : false
    }
    
    /// This method takes a double amount and round to the nearest 1 decimal point
    ///
    /// - Parameter amount: an amount in double
    /// - Returns: amount rounded to the nearest 1 decimal point
    
    func roundToOnewDecimal(_ amount: Double) -> Double {
        return round(amount * 10)/10
    }
    
}
