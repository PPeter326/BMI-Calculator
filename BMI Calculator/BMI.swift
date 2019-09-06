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
            return #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1).withAlphaComponent(alpha)
        case .normalWeight:
            return #colorLiteral(red: 0.1683373186, green: 0.7086806256, blue: 0.2502075166, alpha: 1).withAlphaComponent(alpha)
        case .overweight:
            return #colorLiteral(red: 0.9262628425, green: 0.5530543951, blue: 0.02845006804, alpha: 1).withAlphaComponent(alpha)
        case .obesity:
            return #colorLiteral(red: 0.8397540728, green: 0.2483899519, blue: 0.209886851, alpha: 1).withAlphaComponent(alpha)
        case .undetermined:
            return #colorLiteral(red: 0.7764705882, green: 0.7764705882, blue: 0.7764705882, alpha: 1).withAlphaComponent(alpha)
        }
    }
}
