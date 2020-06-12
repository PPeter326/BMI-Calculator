//
//  BMI.swift
//  BMI Calculator
//
//  Created by Peter Wu on 8/5/19.
//  Copyright © 2019 Peter Wu. All rights reserved.
//

import Foundation
import UIKit

extension BMICategory {
    
    func color() -> UIColor {
        let alpha: CGFloat = 1.00
        switch self {
        case .underWeight:
            return #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1).withAlphaComponent(alpha)
        case .normalWeight:
            return #colorLiteral(red: 0.1683373186, green: 0.7086806256, blue: 0.2502075166, alpha: 1).withAlphaComponent(alpha)
        case .overWeight:
            return #colorLiteral(red: 0.9262628425, green: 0.5530543951, blue: 0.02845006804, alpha: 1).withAlphaComponent(alpha)
        case .obese:
            return #colorLiteral(red: 0.8397540728, green: 0.2483899519, blue: 0.209886851, alpha: 1).withAlphaComponent(alpha)
        }
    }
}
