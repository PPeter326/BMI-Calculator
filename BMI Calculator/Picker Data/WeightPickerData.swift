//
//  Weight.swift
//  BMI Calculator
//
//  Created by Peter Wu on 8/5/19.
//  Copyright © 2019 Peter Wu. All rights reserved.
//

import Foundation

/// Contains weight properties that corresponds to pickerview components, as well as measurement properties that holds value entered via pickerview in imperial and metric system context
/// The pickerview have two sets of measurement values at any given time - for example, 185.5 (185 and 0.5) lbbs in the imperial context, and 73.5 (73 and 0.5) kgs in metric system context
struct WeightPickerData {
    
    /// Represent the imperial measurement value that corresponds to the pickerview components.  When this property is set, it will reset both pounds and poundsDecimal components.
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
    /// Holds value from pounds component in pickerview
    var poundsComponent: Int = 170
    /// Holds value from pounds decimal component in pickerview
    var poundsDecimalComponent: Int = 0
    
    /// Represent the metric measurement value that corresponds to the pickerview components.  When this property is set, it will reset both kilogram and kilogramDecimal components.
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
    /// Holds value from kilogram component in pickerview
    var kilogramComponent = 50
    /// Holds value from kilogram decimal component in pickerview
    var kilogramDecimalComponent = 9
    
}
