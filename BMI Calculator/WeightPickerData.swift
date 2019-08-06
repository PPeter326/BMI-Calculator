//
//  Weight.swift
//  BMI Calculator
//
//  Created by Peter Wu on 8/5/19.
//  Copyright © 2019 Peter Wu. All rights reserved.
//

import Foundation

struct WeightPickerData {
    
    var weightInLbs: Measurement<UnitMass> {
        get {
            return Measurement(value: Double(poundsComponent) + Double(poundsDecimalComponent) / 10, unit: UnitMass.pounds)
        }
        set {
            let newValue = newValue.value
            poundsComponent = Int(newValue)
            let decimalDifference = newValue - Double(poundsComponent)
            let decimalDifferenceInTenths = decimalDifference * 10
            let decimalDifferenceInTenthsRounded = round(decimalDifferenceInTenths)
            poundsDecimalComponent = Int(decimalDifferenceInTenthsRounded)
        }
    }
    var poundsComponent: Int = 170
    var poundsDecimalComponent: Int = 0
    
    var weightInKgs: Measurement<UnitMass> {
        get {
            return Measurement(value: Double(kilogramComponent) + Double(kilogramDecimalComponent) / 10, unit: UnitMass.kilograms)
        }
        set {
            let newValue = newValue.value
            kilogramComponent = Int(newValue)
            let decimalDifference = newValue - Double(kilogramComponent)
            let decimalDifferenceInTenths = decimalDifference * 10
            let decimalDifferenceInTenthsRounded = round(decimalDifferenceInTenths)
            kilogramDecimalComponent = Int(decimalDifferenceInTenthsRounded)
        }
    }
    var kilogramComponent = 50
    var kilogramDecimalComponent = 9
    
}
