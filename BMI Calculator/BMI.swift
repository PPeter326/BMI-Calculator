//
//  BMI.swift
//  BMI Calculator
//
//  Created by Peter Wu on 8/5/19.
//  Copyright © 2019 Peter Wu. All rights reserved.
//

import Foundation
import UIKit

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

extension BMICategory {
    
    func color() -> UIColor {
        switch self {
        case .underweight:
            return #colorLiteral(red: 0.8439414501, green: 0.4790760279, blue: 0, alpha: 1)
        case .normalWeight:
            return #colorLiteral(red: 0.2174585164, green: 0.8184141517, blue: 0, alpha: 1)
        case .overweight:
            return #colorLiteral(red: 1, green: 0.4863265157, blue: 0, alpha: 1)
        case .obesity:
            return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case .undetermined:
            return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
}
