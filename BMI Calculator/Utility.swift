//
//  Utility.swift
//  BMI Calculator
//
//  Created by Peter Wu on 11/15/18.
//  Copyright © 2018 Peter Wu. All rights reserved.
//

import Foundation


/// Enum for categorizing two types of input.  An input is either metric or imperial system.
///
/// - metric: represents metric system input
/// - imperial: represents imperial system input
enum MeasurementSystem: Int, Codable {
    
    case metric
    case imperial
}

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

