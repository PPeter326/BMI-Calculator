//
//  Utility.swift
//  BMI Calculator
//
//  Created by Peter Wu on 11/15/18.
//  Copyright © 2018 Peter Wu. All rights reserved.
//

import Foundation

extension Double {
    
    /// calculates kilogram equivalent of pound
    var lbToKg: Double {
        return self * 0.453592
    }
    
    /// Calculates meters equivalent of inches
    var inchToMeter: Double {
        return self * 0.0254
    }
    
}

