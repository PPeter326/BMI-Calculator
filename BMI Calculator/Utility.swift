//
//  Utility.swift
//  BMI Calculator
//
//  Created by Peter Wu on 11/15/18.
//  Copyright © 2018 Peter Wu. All rights reserved.
//

import Foundation

enum MeasurementSystem: Int, Codable {
    
    case metric
    case imperial
}

extension Double {
    
    var lbToKg: Double {
        return self * 0.453592
    }
    
    var inchToMeter: Double {
        return self * 0.0254
    }
    
    var inchToCentimeter: Double {
        return self.inchToMeter / 100
    }
}

