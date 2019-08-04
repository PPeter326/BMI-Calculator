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
    
    /// The userInput encapsulates the data generated by the user and is saved into the file system.  If a user file existed, the userInput will load when the app opens and populates the views with user's data
    private var userInput: Measurement {
        get {
            return Measurement(weightInLbs: weightInLbs, heightInInches: totalHeightInInches, weightInKgs: weightInKgs, totalHeightInCm: totalHeightCentimeters)
        }
        set {
            weightInLbs = newValue.weightInLbs
            totalHeightInInches = newValue.totalHeightInInches
            weightInKgs = newValue.weightInKgs
            totalHeightCentimeters = newValue.totalHeightInCm
        }
    }
    
    // MARK: - Weight/Height Input
    private var weightInLbsWholeNumber = 170
    private var weightInLbsDecimal = 0
    private var weightInLbs: Double {
        get {
            return Double(weightInLbsWholeNumber) + Double(weightInLbsDecimal) / 10
        }
        set {
            weightInLbsWholeNumber = Int(newValue)
            let decimalDifference = newValue - Double(weightInLbsWholeNumber)
            let decimalDifferenceInTenths = decimalDifference * 10
            let decimalDifferenceInTenthsRounded = round(decimalDifferenceInTenths)
            weightInLbsDecimal = Int(decimalDifferenceInTenthsRounded)
        }
    }
    private var weightInKgWholeNumber = 50
    private var weightInKgDecimal = 9
    private var weightInKgs: Double {
        get {
            return Double(weightInKgWholeNumber) + Double(weightInKgDecimal) / 10
        }
        set {
            weightInKgWholeNumber = Int(newValue)
            let decimalDifference = newValue - Double(weightInKgWholeNumber)
            let decimalDifferenceInTenths = decimalDifference * 10
            let decimalDifferenceInTenthsRounded = round(decimalDifferenceInTenths)
            weightInKgDecimal = Int(decimalDifferenceInTenthsRounded)
        }
    }
    
    private var heightInFt: Int = 5
    private var heightInInches: Int = 10
    private var totalHeightInInches: Double {
        get {
          return Double(heightInFt * 12) + Double(heightInInches)
        }
        set {
            heightInFt = Int(newValue / 12)
            heightInInches = Int(newValue) % 12
        }
    }
    
    private var heightInMeter = 1
    private var heightInCentimeter = 60
    private var totalHeightCentimeters: Double {
        get {
            return Double(heightInMeter * 100) + Double(heightInCentimeter)
        }
        set {
            heightInMeter = Int(newValue / 100)
            heightInCentimeter = Int(newValue) % 100
        }
    }
    

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
        switch weightInputMeasurement {
        case .imperial:
            return weightInLbs.lbToKg
        case .metric:
            return weightInKgs
        }
    }
    
    private func getHeightValue() -> Double {
        switch heightInputMeasurement {
        case .imperial:
            return totalHeightInInches.inchToMeter
        case .metric:
            return totalHeightCentimeters / 100
        }
    }
    
    
    private var BMIDescription: String? {
        return BMI != nil ? category(of: BMI!).describe() : nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial set up
        inputState = .none
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
        deactivateInput()
        updateAllUI()
    }
    
    
    @IBAction func WeightButtonTouched(_ sender: UIButton? = nil) {
        if inputState == .weightInput {
            deactivateInput()
        } else {
            activateWeightInput()
        }
    }
    
    @IBAction func heightButtonTouched(_ sender: UIButton? = nil) {
        if inputState == .heightInput {
            deactivateInput()
        } else {
            activateHeightInput()
        }
    }
    
    
    
    @IBAction func segmentedControlTouched(_ sender: UISegmentedControl) {
        updateInputMeasurement()
        // reload pickerView to reflect input measurement
        pickerView.reloadAllComponents()
        // pickerview select proper values
        inputState == .weightInput ? pickerViewSelectsWeight() : pickerViewSelectsHeight()
        // update weight/height button
        updateWeightButton()
        updateHeightButton()
    }
    
    /// Updates inputType (weight/height input) and input measurement (imperial/metric)
    private func updateInputMeasurement() {
        // update input measurement
        if inputState == .weightInput {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                weightInputMeasurement = .imperial
            case 1:
                weightInputMeasurement = .metric
            default:
                break
            }
        } else if inputState == .heightInput {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                heightInputMeasurement = .imperial
            case 1:
                heightInputMeasurement = .metric
            default:
                break
            }
        }
    }
    
    // MARK: - Input
    
    private var inputState: InputState = .none
//    var measurementSystem: MeasurementSystem = .imperial
    private var weightInputMeasurement: MeasurementSystem = .imperial
    private var heightInputMeasurement: MeasurementSystem = .imperial
    
    
    
    private func deactivateInput() {
        inputState = .none
        updateAllUI()
    }
    
    private func activateWeightInput() {
        inputState = .weightInput
        updateAllUI()
        pickerViewSelectsWeight()
    }
    
    private func activateHeightInput() {
        inputState = .heightInput
        updateAllUI()
        pickerViewSelectsHeight()
    }
    
    private func pickerViewSelectsWeight() {
        if weightInputMeasurement == .imperial {
            let weightInLbsWholeNumberIndex = ImperialNumberPickerViewRange.weightWholeNumberRange.firstIndex(of: weightInLbsWholeNumber)!
            let weightInLbsDecimalIndex = ImperialNumberPickerViewRange.weightDecimalRange.firstIndex(of: weightInLbsDecimal)!
            pickerView.selectRow(weightInLbsWholeNumberIndex, inComponent: 0, animated: false)
            pickerView.selectRow(weightInLbsDecimalIndex, inComponent: 1, animated: false)
        } else if weightInputMeasurement == .metric {
            let weightInKgWholeNumberIndex = MetricNumberPickerViewRange.weightWholeNumberRange.firstIndex(of: weightInKgWholeNumber)!
            let weightInKgDecimalIndex = MetricNumberPickerViewRange.weightDecimalRange.firstIndex(of: weightInKgDecimal)!
            pickerView.selectRow(weightInKgWholeNumberIndex, inComponent: 0, animated: false)
            pickerView.selectRow(weightInKgDecimalIndex, inComponent: 1, animated: false)
        }
    }
    
    private func pickerViewSelectsHeight() {
        
        if heightInputMeasurement == .imperial {
            let heightInFeetIndex = ImperialNumberPickerViewRange.heightInFeetRange.firstIndex(of: heightInFt)!
            let heightInInchIndex = ImperialNumberPickerViewRange.heightInInchesRange.firstIndex(of: heightInInches)!
            pickerView.selectRow(heightInFeetIndex, inComponent: 0, animated: false)
            pickerView.selectRow(heightInInchIndex, inComponent: 2, animated: false)
        } else if heightInputMeasurement == .metric {
            let heightInMeterIndex = 0
            let heightInCentimeterIndex = MetricNumberPickerViewRange.heightInCentimeterRange.firstIndex(of: heightInCentimeter)!
            pickerView.selectRow(heightInMeterIndex, inComponent: 0, animated: false)
            pickerView.selectRow(heightInCentimeterIndex, inComponent: 2, animated: false)
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
        if inputState == .weightInput {
            weightButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        } else {
            weightButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
        }
        // update button title dpeneding on measurement system selected by user
        switch weightInputMeasurement {
        case .imperial:
            weightButton.setTitle("\(weightInLbs) lbs", for: .normal)
        case .metric:
            weightButton.setTitle("\(weightInKgs) kg", for: .normal)
        }
    }
    
    private func updateHeightButton() {
        // update button title color depending on input state
        if inputState == .heightInput {
            heightButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        } else {
            heightButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
        }
        // update button title dpeneding on measurement system selected by user
        switch heightInputMeasurement {
        case .imperial:
            heightButton.setTitle("\(heightInFt) ft \(heightInInches) in", for: .normal)
        case .metric:
            heightButton.setTitle("\(heightInMeter) m \(heightInCentimeter) cm", for: .normal)
        }
    }
    
    private func updateSegmentedControl() {
        segmentedControl.isHidden = (inputState == .none)
        
        switch inputState  {
        case .weightInput:
            segmentedControl.setTitle("Lbs", forSegmentAt: 0)
            segmentedControl.setTitle("Kg", forSegmentAt: 1)
            if weightInputMeasurement == .imperial {
                segmentedControl.selectedSegmentIndex = 0
            } else {
                segmentedControl.selectedSegmentIndex = 1
            }
        case .heightInput:
            segmentedControl.setTitle("Ft/In", forSegmentAt: 0)
            segmentedControl.setTitle("M/Cm", forSegmentAt: 1)
            if heightInputMeasurement == .imperial {
                segmentedControl.selectedSegmentIndex = 0
            } else {
                segmentedControl.selectedSegmentIndex = 1
            }
        case .none:
            break
        }
    }
    
    private func updatePickerView() {
        
        pickerView.isHidden = (inputState == .none)
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
    
    
    
    private func category(of BMI: Double) -> BMICategory {
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
    
    
    private enum BMICategory {
        
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

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - PickerView Delegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch inputState {
        case .weightInput:
            if weightInputMeasurement == .imperial {
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
            } else if weightInputMeasurement == .metric {
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
        case .heightInput:
            if heightInputMeasurement == .imperial {
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
            } else if heightInputMeasurement == .metric {
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
        case .none:
            return nil
        }
        
        return nil
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch inputState {
        case .weightInput:
            if weightInputMeasurement == .imperial {
                switch component {
                case 0:
                    weightInLbsWholeNumber = ImperialNumberPickerViewRange.weightWholeNumberRange[row]
                case 1:
                    weightInLbsDecimal = ImperialNumberPickerViewRange.weightDecimalRange[row]
                default:
                    break
                }
            } else if weightInputMeasurement == .metric {
                switch component {
                case 0:
                    weightInKgWholeNumber = MetricNumberPickerViewRange.weightWholeNumberRange[row]
                case 1:
                    weightInKgDecimal = MetricNumberPickerViewRange.weightDecimalRange[row]
                default:
                    break
                }
            }
            updateWeightButton()
        case .heightInput:
            if heightInputMeasurement == .imperial {
                switch component {
                case 0:
                    heightInFt = ImperialNumberPickerViewRange.heightInFeetRange[row]
                case 2:
                    heightInInches = ImperialNumberPickerViewRange.heightInInchesRange[row]
                default:
                    break
                }
            } else if heightInputMeasurement == .metric {
                switch component {
                case 0:
                    heightInMeter = MetricNumberPickerViewRange.heightInMeterRange
                case 2:
                    heightInCentimeter = MetricNumberPickerViewRange.heightInCentimeterRange[row]
                default:
                    break
                }
            }
            updateHeightButton()
        case .none:
            break
        }
        // save user input
        Measurement.saveToFile(measurement: userInput)
    }
    
    // MARK: - PickerView Datasource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return inputState == .weightInput ? 3 : 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch inputState {
        case .weightInput:
            if weightInputMeasurement == .imperial {
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
            } else if weightInputMeasurement == .metric {
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
        case .heightInput:
            if heightInputMeasurement == .imperial {
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
            } else if heightInputMeasurement == .metric {
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
        case .none:
            return 1
        }
        return 1
    }
}


extension ViewController {
    
    // MARK: - Input State Management
    /// There are three mutually exclusive state.  Either the user is inputting weight, or inputting height, or simply viewing (none).  InputState enum
    /// encapsulates these mutually exclusive state.
    ///
    private enum InputState {
        case weightInput
        case heightInput
        case none
    }
    
    /// Enum for categorizing two types of input.  An input is either metric or imperial system.
    ///
    /// - metric: represents metric system input
    /// - imperial: represents imperial system input
    private enum MeasurementSystem: Int, Codable {
        case metric
        case imperial
    }
}

