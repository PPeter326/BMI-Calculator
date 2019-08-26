//
//  BackgroundView.swift
//  BMI Calculator
//
//  Created by Peter Wu on 8/25/19.
//  Copyright © 2019 Peter Wu. All rights reserved.
//

import UIKit
@IBDesignable
class BackgroundView: UIView {

    @IBInspectable var cornerRadius:CGFloat = 35 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
