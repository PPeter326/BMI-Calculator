//
//  Height.swift
//  BMI Calculator
//
//  Created by Peter Wu on 8/5/19.
//  Copyright © 2019 Peter Wu. All rights reserved.
//

import Foundation

struct Height {
    var heightInFt: Int = 5
    var heightInInches: Int = 10
    var totalHeightInInches: Double {
        get {
            return Double(heightInFt * 12) + Double(heightInInches)
        }
        set {
            heightInFt = Int(newValue / 12)
            heightInInches = Int(newValue) % 12
        }
    }
    
    var heightInMeter = 1
    var heightInCentimeter = 60
    var totalHeightCentimeters: Double {
        get {
            return Double(heightInMeter * 100) + Double(heightInCentimeter)
        }
        set {
            heightInMeter = Int(newValue / 100)
            heightInCentimeter = Int(newValue) % 100
        }
    }
}
