//
//  Height.swift
//  BMI Calculator
//
//  Created by Peter Wu on 8/5/19.
//  Copyright © 2019 Peter Wu. All rights reserved.
//

import Foundation

struct HeightPickerData {
    var feetComponent: Int = 5
    var inchComponent: Int = 10
    var totalHeightInInches: Measurement<UnitLength> {
        get {
            return Measurement(value: Double(feetComponent * 12) + Double(inchComponent), unit: UnitLength.inches)
        }
        set {
            let newValue = newValue.value
            feetComponent = Int(newValue / 12)
            inchComponent = Int(newValue) % 12
        }
    }
    
    var meterComponent = 1
    var centimeterComponent = 60
    var totalHeightCentimeters: Measurement<UnitLength> {
        get {
            return Measurement(value: Double(meterComponent * 100) + Double(centimeterComponent), unit: UnitLength.centimeters)
        }
        set {
            let newValue = newValue.value
            meterComponent = Int(newValue / 100)
            centimeterComponent = Int(newValue) % 100
        }
    }
}
