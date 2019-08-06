//
//  BMI.swift
//  BMI Calculator
//
//  Created by Peter Wu on 8/5/19.
//  Copyright © 2019 Peter Wu. All rights reserved.
//

import Foundation

enum BMICategory {
    
    case underweight, normalWeight, overweight, obesity, undetermined
    
    func describe() -> String {
        switch self {
        case .underweight:
            return "Underweight BMI"
        case .normalWeight:
            return "Normal Weight BMI"
        case .overweight:
            return "Overweight BMI"
        case .obesity:
            return "Obesity BMI"
        case .undetermined:
            return "Sorry, we're unable to determine your BMI"
        }
    }
    
    static func category(of BMI: Double) -> BMICategory {
        switch BMI {
        case 0..<18.5:
            return .underweight
        case 18.5..<25:
            return .normalWeight
        case 25..<30:
            return .overweight
        case 30...:
            return .obesity
        default:
            return .undetermined
        }
    }
}
