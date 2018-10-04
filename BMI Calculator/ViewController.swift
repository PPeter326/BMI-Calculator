//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Peter Wu on 9/22/18.
//  Copyright © 2018 Peter Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    @IBOutlet weak var weightButton: UIButton!
    @IBOutlet weak var heightButton: UIButton!
    @IBOutlet weak var BMILabel: UILabel!
    @IBOutlet weak var BMICategoryLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: Weight/Height Input
    var weightInLbsWholeNumber = 170
    var weightInLbsDecimal = 0
    var weightInLbs: Double {
        return Double(weightInLbsWholeNumber) + Double(weightInLbsDecimal) / 10
    }
    
    var heightInFt: Int = 5
    var heightInInches: Int = 10
    var totalHeightInches: Double {
      return Double(heightInFt * 12) + Double(heightInInches)
    }
    
    let weightWholeNumberRange = Array(90...345)
    let weightDecimalRange = Array(0...9)
    let heightInFeetRange = Array(4...6)
    let heightInInchesRange = Array(0...10)
    
    // MARK: BMI
    var BMI: Double? {
        return calculateBMI()
    }
    var BMIDescription: String? {
        return BMI != nil ? category(of: BMI!).describe() : nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputType = .none
        updateUI()
    }
    

    // MARK: - User Interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // When user touches outside of the controls
        // switch out of input mode
        // update UI
        deactivateInput()
        updateUI()
    }
    
    
    @IBAction func WeightButtonTouched(_ sender: UIButton? = nil) {
        if pickerView.isHidden == true {
            activateWeightInput()
        } else {
            if inputType == .weightInput {
                deactivateInput()
            } else {
                activateWeightInput()
            }
        }
    }
    
    @IBAction func heightButtonTouched(_ sender: UIButton? = nil) {
        if pickerView.isHidden == true {
            activateHeightInput()
        } else {
            if inputType == .heightInput {
                deactivateInput()
            } else {
                activateHeightInput()
            }
        }
    }
    
    // MARK: -Input
    
    var inputType: InputType = .weightInput
    
    enum InputType {
        case weightInput
        case heightInput
        case none
    }
    
    private func deactivateInput() {
        inputType = .none
        updateUI()
    }
    
    private func activateWeightInput() {
        inputType = .weightInput
        updateUI()
    }
    
    private func activateHeightInput() {
        inputType = .heightInput
        updateUI()
    }
    
    
    // MARK: - UI Update
    private func updateUI() {
        
        // update pickerview
        pickerView.reloadAllComponents()
        
        // update height and weight input buttons
        switch inputType {
        case .weightInput:
            weightButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            heightButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
            // update default pickerview value for weight input
            pickerView.isHidden = false
            let weightInLbsWholeNumberIndex = weightWholeNumberRange.firstIndex(of: weightInLbsWholeNumber)!
            pickerView.selectRow(weightInLbsWholeNumberIndex, inComponent: 0, animated: false)
        case .heightInput:
            heightButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            weightButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
            // update default pickerview value for height input
            pickerView.isHidden = false
            let heightInFeetIndex = heightInFeetRange.firstIndex(of: heightInFt)!
            let heightInInchIndex = heightInInchesRange.firstIndex(of: heightInInches)!
            pickerView.selectRow(heightInFeetIndex, inComponent: 0, animated: false)
            pickerView.selectRow(heightInInchIndex, inComponent: 2, animated: false)
        case .none:
            weightButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
            heightButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
            pickerView.isHidden = true
        }
        
        weightButton.setTitle("\(weightInLbs) lbs", for: .normal)
        heightButton.setTitle("\(heightInFt) ft \(heightInInches) in", for: .normal)
        
        
        
        // update BMI Label
        if let BMI = BMI, let BMIDescription = BMIDescription {
            BMILabel.text = "\(BMI)"
            BMICategoryLabel.text = "\(BMIDescription)"
        } else {
            BMILabel.text = "N/A"
            BMICategoryLabel.text = "We can't calculate based on your height and weight"
        }
    }
    
   
    
   
    
    
    // MARK: - PickerView Delegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if inputType == .weightInput {
            switch component {
            case 0:
                return String(weightWholeNumberRange[row])
            case 1:
                return ".\(weightDecimalRange[row])"
            case 2:
                return "lbs"
            default:
                return nil
            }
        } else {
            switch component {
            case 0:
                return String(heightInFeetRange[row])
            case 1:
                return "ft"
            case 2:
                return "\(heightInInchesRange[row])"
            case 3:
                return "in"
            default:
                return nil
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if inputType == .weightInput {
            switch component {
            case 0:
                weightInLbsWholeNumber = weightWholeNumberRange[row]
            case 1:
                weightInLbsDecimal = weightDecimalRange[row]
            default:
                break
            }
        } else {
            switch component {
            case 0:
                heightInFt = heightInFeetRange[row]
            case 2:
                heightInInches = heightInInchesRange[row]
            default:
                break
            }
        }
        
        updateUI()
    }
    
    // MARK: - pickerView Datasource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return inputType == .weightInput ? 3 : 4
    }
    
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if inputType == .weightInput {
                switch component {
                case 0:
                    return weightWholeNumberRange.count
                case 1:
                    return weightDecimalRange.count
                case 2:
                    return 1
                default:
                    return 1
                }
            } else {
                switch component {
                case 0:
                    return heightInFeetRange.count
                case 1:
                    return 1
                case 2:
                    return heightInInchesRange.count
                default:
                    return 1
                }
            }
        }
    // MARK: -
        
    
    
    
    
    
    /// Calculates BMI based on value stored in weightInLbs, heightInFt, and heightInInches
    /// if the value are within height and weight range established in NIH BMI table
    ///
    /// - Returns: BMI (Double) if weight and height data are valid.  Returns nil otherwise
    func calculateBMI() -> Double? {
        
        // Validate weight and height data
        if validHeightAndWeight() {
            let heightInMeter = totalHeightInches.inchToMeter
            let weightInKg = weightInLbs.lbToKg
            let BMI = weightInKg / (heightInMeter * heightInMeter)
            let roundedBMI = roundToOnewDecimal(BMI)
            return roundedBMI
        } else {
            return nil
        }
        
    }
    
    
    /// This method takes a double amount and round to the nearest 1 decimal point
    ///
    /// - Parameter amount: an amount in double
    /// - Returns: amount rounded to the nearest 1 decimal point
    func roundToOnewDecimal(_ amount: Double) -> Double {
        return round(amount * 10)/10
    }
    
    
    /// Checks weightInLbs and height sum from heightInFt and heightInInches to make sure they're:
    /// 1. Not Empty
    /// 2. Within valid range
    /// - Returns: true if weight and height are not empty and are within valid range; false otherwise
    func validHeightAndWeight() -> Bool {
        
        // Check weight and height to make sure it's within valid range
        let validHeightRangeInInches = 58.0...76.0
        let validWeightRangeInLbs = 91.0...443.0
        
        return validWeightRangeInLbs.contains(weightInLbs) && validHeightRangeInInches.contains(totalHeightInches) ? true : false
    }
    
    func category(of BMI: Double) -> BMICategory {
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
    }
    


}

extension Double {
    
    var lbToKg: Double {
        return self * 0.453592
    }
    
    var inchToMeter: Double {
        return self * 0.0254
    }
    
}

