//
//  Height.swift
//  BMI Calculator
//
//  Created by Peter Wu on 8/5/19.
//  Copyright © 2019 Peter Wu. All rights reserved.
//

import Foundation


/// Contains height properties that corresponds to pickerview components, as well as measurement properties that holds value entered via pickerview in imperial and metric system context
/// The pickerview have two sets of measurement values at any given time - for example, 6 ft 3 inches in the imperial context, and 1 meter 87 centimeters in metric system context
struct HeightPickerData {
    
    /// Holds value from feet component in pickerview
    var feetComponent: Int = 5
    
    /// Holds value from inch component in pickerview
    var inchComponent: Int = 10
    
    /// Represent the imperial measurement value that corresponds to the pickerview components.  When this property is set, it will reset both feet and inch components.
    var totalHeightInInches: Measurement<UnitLength> {
        get {
            return Measurement(value: Double(feetComponent * 12) + Double(inchComponent), unit: UnitLength.inches)
        }
        set {
            let newValue = newValue.value
            feetComponent = Int(newValue) / 12
            inchComponent = Int(newValue) % 12
        }
    }
    
    /// Holds value from meter component in pickerview
    var meterComponent:Int = 1
    /// Holds value from centimeter component in pickerview
    var centimeterComponent: Int = 60
    
    /// Represent the metric measurement value that corresponds to the pickerview components.  When this property is set, it will reset both meter and centimeter components.
    var totalHeightCentimeters: Measurement<UnitLength> {
        get {
            return Measurement(value: Double(meterComponent * 100) + Double(centimeterComponent), unit: UnitLength.centimeters)
        }
        set {
            let newValue = newValue.value
            meterComponent = Int(newValue) / 100
            centimeterComponent = Int(newValue) % 100
        }
    }
}
