//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Peter Wu on 9/22/18.
//  Copyright © 2018 Peter Wu. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    // MARK: - Views
    @IBOutlet weak var weightButton: UIButton!
    @IBOutlet weak var heightButton: UIButton!
    @IBOutlet weak var BMILabel: UILabel!
    @IBOutlet weak var BMICategoryLabel: UILabel!
    @IBOutlet weak var pickerView: BodyMeasurementPickerView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var BMIBackground: BackgroundView!

    
    
    
    // MARK: - Model
    
    /**
    The data model for ViewController.
     
    When being accessed, it captures the data context (weightInLbs, totalHeightInInches, weightInKgs, and totalHeightCentimeters) from the view controller.  This happens when user selected a value on pickerview, which triggers a save of file.
     
    When being set, it resets the data context (weightInLbs, totalHeightInInches, weightInKgs, and totalHeightCentimeters) used by the ViewController.  This happens in viewdidLoad initial set up, when either an existing file loads from disk or a sample file is loaded otherwise.
    */
    private var bodyMeasurement: BodyMeasurement!
    
    // MARK: - Weight/Height Input
    
    private struct MeasurementRange {
        static let heightRange = Measurement(value: 57.0, unit: UnitLength.inches)...Measurement(value: 83.0, unit: UnitLength.inches)
        static let weightRange = Measurement(value: 91.0, unit: UnitMass.pounds)...Measurement(value: 443.0, unit: UnitMass.pounds)
    }
    
    private struct ImperialNumberPickerViewRange {
        static let weightWholeNumberRange = Array(91...443)
        static let weightDecimalRange = Array(0...9)
        static let heightInFeetRange = Array(4...6)
        static let heightInInchesRange = Array(0...11)
    }
    
    private struct MetricNumberPickerViewRange {
        static let weightWholeNumberRange = Array(41...200)
        static let weightDecimalRange = Array(0...9)
        static let heightInMeterRange = Array(1...2)
        static let heightInCentimeterRange = Array(0...99)
    }
    
    // MARK: - Formatter
    private let weightNumberFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        return formatter
    }()
    
    private let heightNumberFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    // MARK: - BMI
    private var result: (BMIError?, BMIResult?)
    
    // MARK: - Initial Set-Up
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = UIColor(named: "BackgroundColor")
        view.backgroundColor = color
        
        // Initial set up
        if let measurement = BodyMeasurement.loadFromFile() {
            bodyMeasurement = measurement
        } else {
            bodyMeasurement = BodyMeasurement.loadSampleMeasurement()
        }
        calculate()
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
        // The weight input is only "turned off" when weight input was previously active - much like the light bulb is only turned off if it was previoulsy on
        // otherwise, "turn on" weight input.  This is like having multiple light bulbs, and only one could be on at a time.  If the "height light bulb" was previously on, then touching
        // the control at "weight light bulb" will turn it on and turn off the height light bulb.
        if let activeContext = inputCoordinator.currentInputContext(), activeContext.type == .weight {
            inputCoordinator.deactivateInput()
            updateAllUI()
        } else {
            inputCoordinator.activateWeightInput()
            updateAllUI()
            pickerViewSelectsWeight()
        }
    }
    
    @IBAction func heightButtonTouched(_ sender: UIButton? = nil) {
        // See comments at weightButtonTouched(_:) for logic explanation.
        if let activeContext = inputCoordinator.currentInputContext(), activeContext.type == .height {
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
        inputCoordinator.currentInputContext()!.type == .weight ? pickerViewSelectsWeight() : pickerViewSelectsHeight()
        // save user preference on measurement system
        UserDefaults.standard.set(inputCoordinator.weightContext.system.rawValue, forKey: "weightContext")
        UserDefaults.standard.set(inputCoordinator.heightContext.system.rawValue, forKey: "heightContext")
        // update weight/height button and BMI calculation
        updateWeightButton()
        updateHeightButton()
        updateBMILabels()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // collect component data and calculate weight/height
        let currentContext = inputCoordinator.currentInputContext()!
        
        guard let measurementPickerView = pickerView as? BodyMeasurementPickerView else { return }
        
        switch currentContext.type {
        case .weight:
            var weightPicked: Measurement<UnitMass>
            if currentContext.system == .imperial {
                switch component {
                case 0:
                    measurementPickerView.poundsComponent = ImperialNumberPickerViewRange.weightWholeNumberRange[row]
                case 1:
                    measurementPickerView.poundsDecimalComponent = ImperialNumberPickerViewRange.weightDecimalRange[row]
                default:
                    break
                }
                weightPicked = Measurement(value: Double(measurementPickerView.poundsComponent) + Double(measurementPickerView.poundsDecimalComponent) / 10, unit: UnitMass.pounds)
            } else {
                switch component {
                case 0:
                    measurementPickerView.kilogramComponent = MetricNumberPickerViewRange.weightWholeNumberRange[row]
                case 1:
                    measurementPickerView.kilogramDecimalComponent = MetricNumberPickerViewRange.weightDecimalRange[row]
                default:
                    break
                }
                weightPicked = Measurement(value: Double(measurementPickerView.kilogramComponent) + Double(measurementPickerView.kilogramDecimalComponent) / 10, unit: UnitMass.kilograms)
            }
            // Reset pickerview if weight picked is not within range
            if !MeasurementRange.weightRange.contains(weightPicked) {
                if weightPicked < MeasurementRange.weightRange.lowerBound {
                    weightPicked = MeasurementRange.weightRange.lowerBound
                } else if weightPicked > MeasurementRange.weightRange.upperBound {
                    weightPicked = MeasurementRange.weightRange.upperBound
                } else {
                    fatalError("Unaccounted for weightpicked - should not happen")
                }
                // update pickerview
                pickerViewSelectsWeight(weight: weightPicked)
            }
            // update weight
            bodyMeasurement.weight = weightPicked
            updateWeightButton()
            
        case .height:
            var heightPicked: Measurement<UnitLength>
            if currentContext.system == .imperial {
                switch component {
                case 0:
                    measurementPickerView.feetComponent = ImperialNumberPickerViewRange.heightInFeetRange[row]
                case 2:
                    measurementPickerView.inchComponent = ImperialNumberPickerViewRange.heightInInchesRange[row]
                default:
                    break
                }
                heightPicked = Measurement(value: Double(measurementPickerView.feetComponent) * 12 + Double(measurementPickerView.inchComponent), unit: UnitLength.inches)
            } else {
                switch component {
                case 0:
                    measurementPickerView.meterComponent = MetricNumberPickerViewRange.heightInMeterRange[row]
                case 2:
                    measurementPickerView.centimeterComponent = MetricNumberPickerViewRange.heightInCentimeterRange[row]
                default:
                    break
                }
                heightPicked = Measurement(value: Double(measurementPickerView.meterComponent) + Double(measurementPickerView.centimeterComponent) / 100, unit: UnitLength.meters)
            }
            // Reset pickerview if height picked is not within range
            if !MeasurementRange.heightRange.contains(heightPicked) {
                if heightPicked < MeasurementRange.heightRange.lowerBound {
                    heightPicked = MeasurementRange.heightRange.lowerBound
                } else if heightPicked > MeasurementRange.heightRange.upperBound {
                    heightPicked = MeasurementRange.heightRange.upperBound
                } else {
                    fatalError("Unaccounted for heightpicked - should not happen")
                }
                // update pickerview
                pickerViewSelectsHeight(height: heightPicked)
            }
            // update height
            bodyMeasurement.height = heightPicked
            updateHeightButton()
        }
        calculate() // calculate BMI
        updateBMILabels()
        // save user input
        BodyMeasurement.saveToFile(measurement: bodyMeasurement)
        // save user preference on measurement system
        UserDefaults.standard.set(inputCoordinator.weightContext.system.rawValue, forKey: "weightContext")
        UserDefaults.standard.set(inputCoordinator.heightContext.system.rawValue, forKey: "heightContext")
    }
    
    // MARK: - Input
    
    /// Will attempt to load height and weight context (imperial vs metric) of the buttons from UserDefault if they were properly saved, otherwise load imperial system by default
    fileprivate var inputCoordinator:InputCoordinator = {
        let inputCoordinator = InputCoordinator()
        inputCoordinator.heightContext.system = MeasurementContext.MeasurementSystem(rawValue: UserDefaults.standard.integer(forKey: "heightContext")) ?? .imperial
        inputCoordinator.weightContext.system = MeasurementContext.MeasurementSystem(rawValue: UserDefaults.standard.integer(forKey: "weightContext")) ?? .imperial
        return inputCoordinator
    }()
    
    private func pickerViewSelectsWeight(weight: Measurement<UnitMass>! = nil) {
        if let activeContext = inputCoordinator.currentInputContext(), activeContext.type == .weight {
            
            var weight = weight ?? bodyMeasurement.weight
            if activeContext.system == .imperial {
                
                weight.convert(to: UnitMass.pounds)
                let pounds = Int((weight.value * 10).rounded()) // This is to help us get more accurate number
                let (wholeNumber, decimal) = pounds.quotientAndRemainder(dividingBy: 10)
                
                let weightInLbsWholeNumberIndex = ImperialNumberPickerViewRange.weightWholeNumberRange.firstIndex(of: wholeNumber)
                let weightInLbsDecimalIndex = ImperialNumberPickerViewRange.weightDecimalRange.firstIndex(of: decimal)
                
                pickerView.selectRow(weightInLbsWholeNumberIndex!, inComponent: 0, animated: true)
                pickerView.selectRow(weightInLbsDecimalIndex!, inComponent: 1, animated: true)
                
                // pickerVIew update its selection for each component
                pickerView.poundsComponent = wholeNumber
                pickerView.poundsDecimalComponent = decimal
            } else {
                
                weight.convert(to: UnitMass.kilograms)
                let kg = Int((weight.value * 10).rounded())
                let (wholeNumber, decimal) = kg.quotientAndRemainder(dividingBy: 10)
                
                let weightInKgWholeNumberIndex = MetricNumberPickerViewRange.weightWholeNumberRange.firstIndex(of: wholeNumber)
                let weightInKgDecimalIndex = MetricNumberPickerViewRange.weightDecimalRange.firstIndex(of: decimal)
                
                pickerView.selectRow(weightInKgWholeNumberIndex!, inComponent: 0, animated: true)
                pickerView.selectRow(weightInKgDecimalIndex!, inComponent: 1, animated: true)
                
                pickerView.kilogramComponent = wholeNumber
                pickerView.poundsDecimalComponent = decimal
            }
        } else {
            fatalError("Invalid - there should be active context when pickerViewSelectsWeight() is called")
        }
    }
    
    private func pickerViewSelectsHeight(height: Measurement<UnitLength>! = nil) {
        
        if let activeContext = inputCoordinator.currentInputContext(), activeContext.type == .height {
            
            var height = height ?? bodyMeasurement.height
            
            if activeContext.system == .imperial {
                
                height.convert(to: UnitLength.inches) // converts height to inch so it can be rounded
                let heightInInches = Int(height.value.rounded())
                let (ft, inches) = heightInInches.quotientAndRemainder(dividingBy: 12)
                
                let heightInFeetIndex = ImperialNumberPickerViewRange.heightInFeetRange.firstIndex(of: ft)
                let heightInInchIndex = ImperialNumberPickerViewRange.heightInInchesRange.firstIndex(of: inches)
                
                pickerView.selectRow(heightInFeetIndex!, inComponent: 0, animated: true)
                pickerView.selectRow(heightInInchIndex!, inComponent: 2, animated: true)
                
                // update pickerview components
                pickerView.feetComponent = ft
                pickerView.inchComponent = inches
            } else {
                height.convert(to: UnitLength.centimeters)
                let heightInCentimeters = Int(height.value.rounded())
                let (meters, centimeters) = heightInCentimeters.quotientAndRemainder(dividingBy: 100)
                
                let heightInMeterIndex = MetricNumberPickerViewRange.heightInMeterRange.firstIndex(of: meters)
                let heightInCentimeterIndex = MetricNumberPickerViewRange.heightInCentimeterRange.firstIndex(of: centimeters)
                
                pickerView.selectRow(heightInMeterIndex!, inComponent: 0, animated: true)
                pickerView.selectRow(heightInCentimeterIndex!, inComponent: 2, animated: true)
                
                // update pickerview components
                pickerView.meterComponent = meters
                pickerView.centimeterComponent = centimeters
            }
        } else {
            fatalError("Invalid - there should be active context when pickerViewSelectsWeight() is called")
        }
    }
    
    // calculation
    private func calculate() {
        result = BMICalculator.calculate(weight: bodyMeasurement.weight, height: bodyMeasurement.height)
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
        if let activeContext = inputCoordinator.currentInputContext(), activeContext.type == .weight {
            weightButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        } else {
            weightButton.setTitleColor(#colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1), for: .normal)
        }
        // update button title dpeneding on measurement system selected by user
        switch inputCoordinator.weightContext.system {
        case .imperial:
            let weight = bodyMeasurement.weight.converted(to: UnitMass.pounds).value
            let weightString = weightNumberFormatter.string(from: NSNumber(value: weight))
            weightButton.setTitle("\(weightString!) lbs", for: .normal)
        case .metric:
            let weight = bodyMeasurement.weight.converted(to: UnitMass.kilograms).value
            let weightString = weightNumberFormatter.string(from: NSNumber(value: weight))
            weightButton.setTitle("\(weightString!) kg", for: .normal)
        }
    }
    
    private func updateHeightButton() {
        // update button title color depending on input state
        if let activeContext = inputCoordinator.currentInputContext(), activeContext.type == .height {
            heightButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        } else {
            heightButton.setTitleColor(#colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1), for: .normal)
        }
        // update button title dpeneding on measurement system selected by user
        var height = bodyMeasurement.height
        
        switch inputCoordinator.heightContext.system {
            
        case .imperial:
            height.convert(to: UnitLength.inches) // converts height to inch so it can be rounded
            let heightInInches = Int(height.value.rounded())
            let (ft, inches) = heightInInches.quotientAndRemainder(dividingBy: 12)

            let heightString = heightNumberFormatter.string(from: NSNumber(value: ft))! + " ft " + heightNumberFormatter.string(from: NSNumber(value: inches))! + " in"
            heightButton.setTitle(heightString, for: .normal)
            
        case .metric:
            height.convert(to: UnitLength.centimeters)
            let heightInCentimeters = Int(height.value.rounded())
            let (meters, centimeters) = heightInCentimeters.quotientAndRemainder(dividingBy: 100)
            
            let heightString = heightNumberFormatter.string(from: NSNumber(value: meters))! + " m " + heightNumberFormatter.string(from: NSNumber(value: centimeters))! + " cm"
            heightButton.setTitle(heightString, for: .normal)
        }
    }
    
    private func updateSegmentedControl() {
        segmentedControl.isHidden = (inputCoordinator.mode == .Viewing)
        
        if let currentContext = inputCoordinator.currentInputContext() {
        let currentBodyMeasurement = currentContext.type
            switch currentBodyMeasurement  {
            case .weight:
                segmentedControl.setTitle("Lbs", forSegmentAt: 0)
                segmentedControl.setTitle("Kg", forSegmentAt: 1)
                if currentContext.system == .imperial {
                    segmentedControl.selectedSegmentIndex = 0
                } else {
                    segmentedControl.selectedSegmentIndex = 1
                }
            case .height:
                segmentedControl.setTitle("Ft/In", forSegmentAt: 0)
                segmentedControl.setTitle("M/Cm", forSegmentAt: 1)
                if currentContext.system == .imperial {
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
        if let error = result.0 {
            BMILabel.text = "N/A"
            BMIBackground.backgroundColor = UIColor.lightGray
            if error == BMIError.invalidHeight {
                BMICategoryLabel.text = "Height is out of range for accurate calculation"
            } else if error == BMIError.invalidWeight {
                BMICategoryLabel.text = "Weight is out of range for accurate calculation"
            }
        } else if let validResult = result.1 {
            let BMI = validResult.BMI
            BMICategoryLabel.text = validResult.category.describe()
            BMIBackground.backgroundColor = validResult.category.color()
            BMILabel.text = weightNumberFormatter.string(from: NSNumber(value: BMI))
        }
    }
    
}

// MARK: -
extension CalculatorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: PickerView setup/datasource
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currentContext = inputCoordinator.currentInputContext()!
        // weight picker layout
        let weightWholeNumber = 0
        let weightDecimal = 1
        let weightUnit = 2
        
        // height picker layout
        let heightHighNumber = 0
        let heightHighUnit = 1
        let heightLowNumber = 2
        let heightLowUnit = 3
        
        switch currentContext.type {
        case .weight:
            if currentContext.system == .imperial {
                switch component {
                case weightWholeNumber:
                    return String(ImperialNumberPickerViewRange.weightWholeNumberRange[row])
                case weightDecimal:
                    return ".\(ImperialNumberPickerViewRange.weightDecimalRange[row])"
                case weightUnit:
                    return "lbs"
                default:
                    return nil
                }
            } else {
                switch component {
                case weightWholeNumber:
                    return String(MetricNumberPickerViewRange.weightWholeNumberRange[row])
                case weightDecimal:
                    return ".\(MetricNumberPickerViewRange.weightDecimalRange[row])"
                case weightUnit:
                    return "kg"
                default:
                    return nil
                }
            }
        case .height:
            if currentContext.system == .imperial {
                switch component {
                case heightHighNumber:
                    return String(ImperialNumberPickerViewRange.heightInFeetRange[row])
                case heightHighUnit:
                    return "ft"
                case heightLowNumber:
                    return "\(ImperialNumberPickerViewRange.heightInInchesRange[row])"
                case heightLowUnit:
                    return "in"
                default:
                    return nil
                }
            } else {
                switch component {
                case heightHighNumber:
                    return "\(MetricNumberPickerViewRange.heightInMeterRange[row])"
                case heightHighUnit:
                    return "m"
                case heightLowNumber:
                    return "\(MetricNumberPickerViewRange.heightInCentimeterRange[row])"
                case heightLowUnit:
                    return "cm"
                default:
                    return nil
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if let currentContext = inputCoordinator.currentInputContext() {
            switch currentContext.type {
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
        switch currentContext.type {
        case .weight:
            if currentContext.system == .imperial {
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
            if currentContext.system == .imperial {
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
                    return MetricNumberPickerViewRange.heightInMeterRange.count
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
