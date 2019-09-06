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
        let alpha: CGFloat = 1.00
        switch self {
        case .underweight:
            return #colorLiteral(red: 0.8439414501, green: 0.4790760279, blue: 0, alpha: 1).withAlphaComponent(alpha)
        case .normalWeight:
            return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1).withAlphaComponent(alpha)
        case .overweight:
            return #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1).withAlphaComponent(alpha)
        case .obesity:
            return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).withAlphaComponent(alpha)
        case .undetermined:
            return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(alpha)
        }
    }
}
