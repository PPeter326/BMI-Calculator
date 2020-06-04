//
//  BodyMeasurementPickerView.swift
//  BMI Calculator
//
//  Created by Peter Wu on 6/3/20.
//  Copyright © 2020 Peter Wu. All rights reserved.
//

import UIKit

class BodyMeasurementPickerView: UIPickerView {
    
    /// Holds value from pounds component in pickerview
    var poundsComponent: Int = 170
    /// Holds value from pounds decimal component in pickerview
    var poundsDecimalComponent: Int = 0
    
    /// Holds value from kilogram component in pickerview
    var kilogramComponent = 50
    /// Holds value from kilogram decimal component in pickerview
    var kilogramDecimalComponent = 9
    
    /// Holds value from feet component in pickerview
    var feetComponent: Int = 5
    
    /// Holds value from inch component in pickerview
    var inchComponent: Int = 10
    
    /// Holds value from meter component in pickerview
    var meterComponent:Int = 1
    /// Holds value from centimeter component in pickerview
    var centimeterComponent: Int = 60

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
