//
//  Weight.swift
//  BMI Calculator
//
//  Created by Peter Wu on 8/5/19.
//  Copyright © 2019 Peter Wu. All rights reserved.
//

import Foundation

struct Weight {
    var weightInLbs: Double {
        get {
            return Double(weightInLbsWholeNumber) + Double(weightInLbsDecimal) / 10
        }
        set {
            weightInLbsWholeNumber = Int(newValue)
            let decimalDifference = newValue - Double(weightInLbsWholeNumber)
            let decimalDifferenceInTenths = decimalDifference * 10
            let decimalDifferenceInTenthsRounded = round(decimalDifferenceInTenths)
            weightInLbsDecimal = Int(decimalDifferenceInTenthsRounded)
        }
    }
    var weightInLbsWholeNumber: Int = 170
    var weightInLbsDecimal: Int = 0
    
    var weightInKgs: Double {
        get {
            return Double(weightInKgWholeNumber) + Double(weightInKgDecimal) / 10
        }
        set {
            weightInKgWholeNumber = Int(newValue)
            let decimalDifference = newValue - Double(weightInKgWholeNumber)
            let decimalDifferenceInTenths = decimalDifference * 10
            let decimalDifferenceInTenthsRounded = round(decimalDifferenceInTenths)
            weightInKgDecimal = Int(decimalDifferenceInTenthsRounded)
        }
    }
    
    var weightInKgWholeNumber = 50
    var weightInKgDecimal = 9
    
}
