//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Peter Wu on 9/22/18.
//  Copyright © 2018 Peter Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Views
    @IBOutlet weak var weightButton: UIButton!
    @IBOutlet weak var heightButton: UIButton!
    @IBOutlet weak var BMILabel: UILabel!
    @IBOutlet weak var BMICategoryLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Model
    
    /**
    The data model for ViewController.
     
    When being accessed, it captures the data context (weightInLbs, totalHeightInInches, weightInKgs, and totalHeightCentimeters) from the view controller.  This happens when user selected a value on pickerview, which triggers a save of file.
     
    When being set, it resets the data context (weightInLbs, totalHeightInInches, weightInKgs, and totalHeightCentimeters) used by the ViewController.  This happens in viewdidLoad initial set up, when either an existing file loads from disk or a sample file is loaded otherwise.
    */
    private var userInput: Measurement {
        get {
            return Measurement(weightInLbs: weight.weightInLbs, heightInInches: height.totalHeightInInches, weightInKgs: weight.weightInKgs, totalHeightInCm: height.totalHeightCentimeters)
        }
        set {
            weight.weightInLbs = newValue.weightInLbs
            height.totalHeightInInches = newValue.totalHeightInInches
            weight.weightInKgs = newValue.weightInKgs
            height.totalHeightCentimeters = newValue.totalHeightInCm
        }
    }
    
    // MARK: - Weight/Height Input
    
    /// Keeps track of the height/weight values selected by user on pickerview, and stores the value of height/weight from Measurement Data Model.
    private var weight = Weight()
    private var height = Height()
    

    private struct ImperialNumberPickerViewRange {
        static let weightWholeNumberRange = Array(90...443)
        static let weightDecimalRange = Array(0...9)
        static let heightInFeetRange = Array(4...6)
        static let heightInInchesRange = Array(0...11)
    }
    
    private struct MetricNumberPickerViewRange {
        static let weightWholeNumberRange = Array(40...200)
        static let weightDecimalRange = Array(0...9)
        static let heightInMeterRange = 1
        static let heightInCentimeterRange = Array(40...99)
    }
    
    // MARK: - Formatter
    private let numberFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    // MARK: - BMI
    private var calculator = BMICalculator()
    private var BMI: Double? {
      return calculator.calculateBMI(weight: getWeightValue(), height: getHeightValue())
    }
    
    private func getWeightValue() -> Double {
        // if imperial -> return converted weight
        // if metric -> return self
        
        let context = inputCoordinator.weightContext
        switch context.measurementSystem {
        case .imperial:
            return weight.weightInLbs.lbToKg
        case .metric:
            return weight.weightInKgs
        }
    }
    
    private func getHeightValue() -> Double {
        let context = inputCoordinator.heightContext
        switch context.measurementSystem {
        case .imperial:
            return height.totalHeightInInches.inchToMeter
        case .metric:
            return height.totalHeightCentimeters / 100
        }
    }
    
    private var BMIDescription: String? {
        return BMI != nil ? BMICategory.category(of: BMI!).describe() : nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial set up
        if let measurement = Measurement.loadFromFile() {
            userInput = measurement
        } else {
            userInput = Measurement.loadSampleMeasurement()
        }
        updateAllUI()
    }

    // MARK: - User Interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // When user touches outside of the controls
        // switch out of input mode
        // update UI
        inputCoordinator.deactivateInput()
        updateAllUI()
    }
    
    
    @IBAction func WeightButtonTouched(_ sender: UIButton? = nil) {
        if inputCoordinator.currentInputContext() != nil {
            inputCoordinator.deactivateInput()
            updateAllUI()
        } else {
            inputCoordinator.activateWeightInput()
            updateAllUI()
            pickerViewSelectsWeight()
        }
    }
    
    @IBAction func heightButtonTouched(_ sender: UIButton? = nil) {
        if inputCoordinator.currentInputContext() != nil {
            inputCoordinator.deactivateInput()
            updateAllUI()
        } else {
            inputCoordinator.activateHeightInput()
            updateAllUI()
            pickerViewSelectsHeight()
        }
    }
    
    
    @IBAction func segmentedControlTouched(_ sender: UISegmentedControl) {
        inputCoordinator.updateInputMeasurement(forIndex: sender.selectedSegmentIndex)
        // reload pickerView to reflect input measurement
        pickerView.reloadAllComponents()
        // pickerview select proper values based on body measurement of current input context
        inputCoordinator.currentInputContext()!.bodyMeasurement == .weight ? pickerViewSelectsWeight() : pickerViewSelectsHeight()
        // update weight/height button
        updateWeightButton()
        updateHeightButton()
    }
    
    // MARK: - Input
    
    fileprivate var inputCoordinator = InputCoordinator()
    
    private func pickerViewSelectsWeight() {
        if let activeContext = inputCoordinator.currentInputContext(), activeContext.bodyMeasurement == .weight {
            if activeContext.measurementSystem == .imperial {
                let weightInLbsWholeNumberIndex = ImperialNumberPickerViewRange.weightWholeNumberRange.firstIndex(of: weight.weightInLbsWholeNumber)!
                let weightInLbsDecimalIndex = ImperialNumberPickerViewRange.weightDecimalRange.firstIndex(of: weight.weightInLbsDecimal)!
                pickerView.selectRow(weightInLbsWholeNumberIndex, inComponent: 0, animated: false)
                pickerView.selectRow(weightInLbsDecimalIndex, inComponent: 1, animated: false)
            } else {
                let weightInKgWholeNumberIndex = MetricNumberPickerViewRange.weightWholeNumberRange.firstIndex(of: weight.weightInKgWholeNumber)!
                let weightInKgDecimalIndex = MetricNumberPickerViewRange.weightDecimalRange.firstIndex(of: weight.weightInKgDecimal)!
                pickerView.selectRow(weightInKgWholeNumberIndex, inComponent: 0, animated: false)
                pickerView.selectRow(weightInKgDecimalIndex, inComponent: 1, animated: false)
            }
        } else {
            fatalError("Invalid - there should be active context when pickerViewSelectsWeight() is called")
        }
    }
    
    private func pickerViewSelectsHeight() {
        
        if let activeContext = inputCoordinator.currentInputContext(), activeContext.bodyMeasurement == .height {
            if activeContext.measurementSystem == .imperial {
                let heightInFeetIndex = ImperialNumberPickerViewRange.heightInFeetRange.firstIndex(of: height.heightInFt)!
                let heightInInchIndex = ImperialNumberPickerViewRange.heightInInchesRange.firstIndex(of: height.heightInInches)!
                pickerView.selectRow(heightInFeetIndex, inComponent: 0, animated: false)
                pickerView.selectRow(heightInInchIndex, inComponent: 2, animated: false)
            } else {
                let heightInMeterIndex = 0
                let heightInCentimeterIndex = MetricNumberPickerViewRange.heightInCentimeterRange.firstIndex(of: height.heightInCentimeter)!
                pickerView.selectRow(heightInMeterIndex, inComponent: 0, animated: false)
                pickerView.selectRow(heightInCentimeterIndex, inComponent: 2, animated: false)
            }
        } else {
            fatalError("Invalid - there should be active context when pickerViewSelectsWeight() is called")
        }
    }
    
    // MARK: - UI Update
    private func updateAllUI() {
        
        updateWeightButton()
        updateHeightButton()
        updateSegmentedControl()
        updatePickerView()
        updateBMILabels()
    }
    
    private func updateWeightButton() {
        // update button title color depending on input state
        if let activeContext = inputCoordinator.currentInputContext(), activeContext.bodyMeasurement == .weight {
            weightButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        } else {
            weightButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
        }
        // update button title dpeneding on measurement system selected by user
        switch inputCoordinator.weightContext.measurementSystem {
        case .imperial:
            weightButton.setTitle("\(weight.weightInLbs) lbs", for: .normal)
        case .metric:
            weightButton.setTitle("\(weight.weightInKgs) kg", for: .normal)
        }
    }
    
    private func updateHeightButton() {
        // update button title color depending on input state
        if let activeContext = inputCoordinator.currentInputContext(), activeContext.bodyMeasurement == .height {
            heightButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        } else {
            heightButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
        }
        // update button title dpeneding on measurement system selected by user
        switch inputCoordinator.heightContext.measurementSystem {
        case .imperial:
            heightButton.setTitle("\(height.heightInFt) ft \(height.heightInInches) in", for: .normal)
        case .metric:
            heightButton.setTitle("\(height.heightInMeter) m \(height.heightInCentimeter) cm", for: .normal)
        }
    }
    
    private func updateSegmentedControl() {
        segmentedControl.isHidden = (inputCoordinator.mode == .Viewing)
        
        if let currentContext = inputCoordinator.currentInputContext() {
        let currentBodyMeasurement = currentContext.bodyMeasurement
            switch currentBodyMeasurement  {
            case .weight:
                segmentedControl.setTitle("Lbs", forSegmentAt: 0)
                segmentedControl.setTitle("Kg", forSegmentAt: 1)
                if currentContext.measurementSystem == .imperial {
                    segmentedControl.selectedSegmentIndex = 0
                } else {
                    segmentedControl.selectedSegmentIndex = 1
                }
            case .height:
                segmentedControl.setTitle("Ft/In", forSegmentAt: 0)
                segmentedControl.setTitle("M/Cm", forSegmentAt: 1)
                if currentContext.measurementSystem == .imperial {
                    segmentedControl.selectedSegmentIndex = 0
                } else {
                    segmentedControl.selectedSegmentIndex = 1
                }
            }
        }
    }
    
    private func updatePickerView() {
        
        pickerView.isHidden = (inputCoordinator.mode == .Viewing)
        pickerView.reloadAllComponents()
    }
    
    func updateBMILabels() {
        // update BMI Label
        if let BMI = BMI, let BMIDescription = BMIDescription {
            BMILabel.text = numberFormatter.string(from: NSNumber(value: BMI))
            BMICategoryLabel.text = "\(BMIDescription)"
        } else {
            BMILabel.text = "N/A"
            BMICategoryLabel.text = "We can't calculate based on your height and weight"
        }
    }
    
    
    
    
    
    
    

}

// MARK: -
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: PickerView Delegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currentContext = inputCoordinator.currentInputContext()!
        switch currentContext.bodyMeasurement {
        case .weight:
            if currentContext.measurementSystem == .imperial {
                switch component {
                case 0:
                    return String(ImperialNumberPickerViewRange.weightWholeNumberRange[row])
                case 1:
                    return ".\(ImperialNumberPickerViewRange.weightDecimalRange[row])"
                case 2:
                    return "lbs"
                default:
                    return nil
                }
            } else {
                switch component {
                case 0:
                    return String(MetricNumberPickerViewRange.weightWholeNumberRange[row])
                case 1:
                    return ".\(MetricNumberPickerViewRange.weightDecimalRange[row])"
                case 2:
                    return "kg"
                default:
                    return nil
                }
            }
        case .height:
            if currentContext.measurementSystem == .imperial {
                switch component {
                case 0:
                    return String(ImperialNumberPickerViewRange.heightInFeetRange[row])
                case 1:
                    return "ft"
                case 2:
                    return "\(ImperialNumberPickerViewRange.heightInInchesRange[row])"
                case 3:
                    return "in"
                default:
                    return nil
                }
            } else {
                switch component {
                case 0:
                    return String(MetricNumberPickerViewRange.heightInMeterRange)
                case 1:
                    return "m"
                case 2:
                    return "\(MetricNumberPickerViewRange.heightInCentimeterRange[row])"
                case 3:
                    return "cm"
                default:
                    return nil
                }
            }
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currentContext = inputCoordinator.currentInputContext()!
        switch currentContext.bodyMeasurement {
        case .weight:
            if currentContext.measurementSystem == .imperial {
                switch component {
                case 0:
                    weight.weightInLbsWholeNumber = ImperialNumberPickerViewRange.weightWholeNumberRange[row]
                case 1:
                    weight.weightInLbsDecimal = ImperialNumberPickerViewRange.weightDecimalRange[row]
                default:
                    break
                }
            } else {
                switch component {
                case 0:
                    weight.weightInKgWholeNumber = MetricNumberPickerViewRange.weightWholeNumberRange[row]
                case 1:
                    weight.weightInKgDecimal = MetricNumberPickerViewRange.weightDecimalRange[row]
                default:
                    break
                }
            }
            updateWeightButton()
        case .height:
            if currentContext.measurementSystem == .imperial {
                switch component {
                case 0:
                    height.heightInFt = ImperialNumberPickerViewRange.heightInFeetRange[row]
                case 2:
                    height.heightInInches = ImperialNumberPickerViewRange.heightInInchesRange[row]
                default:
                    break
                }
            } else {
                switch component {
                case 0:
                    height.heightInMeter = MetricNumberPickerViewRange.heightInMeterRange
                case 2:
                    height.heightInCentimeter = MetricNumberPickerViewRange.heightInCentimeterRange[row]
                default:
                    break
                }
            }
            updateHeightButton()
        }
        // save user input
        Measurement.saveToFile(measurement: userInput)
    }
    
    // MARK: PickerView Datasource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if let currentContext = inputCoordinator.currentInputContext() {
            switch currentContext.bodyMeasurement {
            case .height:
                return 4
            case .weight:
                return 3
            }
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        let currentContext = inputCoordinator.currentInputContext()!
        switch currentContext.bodyMeasurement {
        case .weight:
            if currentContext.measurementSystem == .imperial {
                switch component {
                case 0:
                    return ImperialNumberPickerViewRange.weightWholeNumberRange.count
                case 1:
                    return ImperialNumberPickerViewRange.weightDecimalRange.count
                case 2:
                    return 1
                default:
                    return 1
                }
            } else {
                switch component {
                case 0:
                    return MetricNumberPickerViewRange.weightWholeNumberRange.count
                case 1:
                    return MetricNumberPickerViewRange.weightDecimalRange.count
                case 2:
                    return 1
                default:
                    return 1
                }
            }
        case .height:
            if currentContext.measurementSystem == .imperial {
                switch component {
                case 0:
                    return ImperialNumberPickerViewRange.heightInFeetRange.count
                case 1:
                    return 1
                case 2:
                    return ImperialNumberPickerViewRange.heightInInchesRange.count
                default:
                    return 1
                }
            } else {
                switch component {
                case 0:
                    return 1
                case 1:
                    return 1
                case 2:
                    return MetricNumberPickerViewRange.heightInCentimeterRange.count
                default:
                    return 1
                }
            }
        }
    }
}
