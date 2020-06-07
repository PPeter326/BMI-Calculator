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
    
    /// Holds value from feet component in pickerview
    var feetComponent: Int = 5
    
    /// Holds value from inch component in pickerview
    var inchComponent: Int = 10
    
    /// Holds value from meter component in pickerview
    var meterComponent:Int = 1
    /// Holds value from centimeter component in pickerview
    var centimeterComponent: Int = 60
    
    // weight picker layout
    static let weightWholeNumber = 0
    static let weightDecimal = 1
    static let weightUnit = 2
    
    // height picker layout
    static let heightHighNumber = 0
    static let heightHighUnit = 1
    static let heightLowNumber = 2
    static let heightLowUnit = 3

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
