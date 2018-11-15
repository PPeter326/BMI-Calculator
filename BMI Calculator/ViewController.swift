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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    
    // MARK: Model
    var userInput: UserInput?
    
    
    // MARK: Weight/Height Input
    var weightInLbsWholeNumber = 170
    var weightInLbsDecimal = 0
    var weightInLbs: Double {
        get {
            return Double(weightInLbsWholeNumber) + Double(weightInLbsDecimal) / 10
        }
        set {
            weightInLbsWholeNumber = Int(newValue)
            weightInLbsDecimal = Int(newValue - Double(weightInLbsWholeNumber))
        }
    }
    var weightInKgWholeNumber = 50
    var weightInKgDecimal = 9
    var weightInKgs: Double {
        get {
            return Double(weightInKgWholeNumber) + Double(weightInKgDecimal) / 10
        }
        set {
            weightInKgWholeNumber = Int(newValue)
            weightInKgDecimal = Int(newValue - Double(weightInKgWholeNumber))
        }
    }
    
    var heightInFt: Int = 5
    var heightInInches: Int = 10
    var totalHeightInches: Double {
        get {
          return Double(heightInFt * 12) + Double(heightInInches)
        }
        set {
            heightInFt = Int(newValue / 12)
            heightInInches = Int(newValue) % 12
        }
    }
    
    var heightInMeter = 1
    var heightInCentimeter = 60
    var totalHeightCentimeters: Double {
        get {
            return Double(heightInMeter * 100) + Double(heightInCentimeter)
        }
        set {
            heightInMeter = Int(newValue / 100)
            heightInCentimeter = Int(newValue) % 100
        }
    }

    struct ImperialNumberRange {
        static let weightWholeNumberRange = Array(90...443)
        static let weightDecimalRange = Array(0...9)
        static let heightInFeetRange = Array(4...6)
        static let heightInInchesRange = Array(0...11)
    }
    
    struct MetricNumberRange {
        static let weightWholeNumberRange = Array(40...200)
        static let weightDecimalRange = Array(0...9)
        static let heightInMeterRange = 1
        static let heightInCentimeterRange = Array(40...99)
    }
    
    
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
        loadUserInput()
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
        // Allows weight input
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
    
    var measurementSystem: MeasurementSystem = .imperial
    
    enum MeasurementSystem {
        case metric
        case imperial
    }
    
    
    // MARK: - UI Update
    private func updateUI() {
        
        // update pickerview
        pickerView.reloadAllComponents()
        
        // update height and weight input buttons
        switch inputType {
        case .weightInput:
            // configure weight button
            weightButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            heightButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
            // configure pickerview for weight input
            pickerView.isHidden = false
            // selects pickerview to previous position
            if measurementSystem == .imperial {
                let weightInLbsWholeNumberIndex = ImperialNumberRange.weightWholeNumberRange.firstIndex(of: weightInLbsWholeNumber)!
                let weightInLbsDecimalIndex = ImperialNumberRange.weightDecimalRange.firstIndex(of: weightInLbsDecimal)!
                pickerView.selectRow(weightInLbsWholeNumberIndex, inComponent: 0, animated: false)
                pickerView.selectRow(weightInLbsDecimalIndex, inComponent: 1, animated: false)
            } else if measurementSystem == .metric {
                let weightInKgWholeNumberIndex = MetricNumberRange.weightWholeNumberRange.firstIndex(of: weightInKgWholeNumber)!
                let weightInKgDecimalIndex = MetricNumberRange.weightDecimalRange.firstIndex(of: weightInKgDecimal)!
                pickerView.selectRow(weightInKgWholeNumberIndex, inComponent: 0, animated: false)
                pickerView.selectRow(weightInKgDecimalIndex, inComponent: 1, animated: false)
            }
            // configure segment control
            segmentedControl.isHidden = false
            segmentedControl.setTitle("Lbs", forSegmentAt: 0)
            segmentedControl.setTitle("Kg", forSegmentAt: 1)
        case .heightInput:
            heightButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            weightButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
            // update default pickerview value for height input
            pickerView.isHidden = false
            if measurementSystem == .imperial {
                let heightInFeetIndex = ImperialNumberRange.heightInFeetRange.firstIndex(of: heightInFt)!
                let heightInInchIndex = ImperialNumberRange.heightInInchesRange.firstIndex(of: heightInInches)!
                pickerView.selectRow(heightInFeetIndex, inComponent: 0, animated: false)
                pickerView.selectRow(heightInInchIndex, inComponent: 2, animated: false)
            } else if measurementSystem == .metric {
                let heightInMeterIndex = 0
                let heightInCentimeterIndex = MetricNumberRange.heightInCentimeterRange.firstIndex(of: heightInCentimeter)!
                pickerView.selectRow(heightInMeterIndex, inComponent: 0, animated: false)
                pickerView.selectRow(heightInCentimeterIndex, inComponent: 2, animated: false)
            }
            // configure segment control
            segmentedControl.isHidden = false
            segmentedControl.setTitle("Ft/In", forSegmentAt: 0)
            segmentedControl.setTitle("M/Cm", forSegmentAt: 1)
        case .none:
            weightButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
            heightButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
            pickerView.isHidden = true
            segmentedControl.isHidden = true
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
        switch inputType {
        case .weightInput:
            if measurementSystem == .imperial {
                switch component {
                case 0:
                    return String(ImperialNumberRange.weightWholeNumberRange[row])
                case 1:
                    return ".\(ImperialNumberRange.weightDecimalRange[row])"
                case 2:
                    return "lbs"
                default:
                    return nil
                }
            } else if measurementSystem == .metric {
                switch component {
                case 0:
                    return String(MetricNumberRange.weightWholeNumberRange[row])
                case 1:
                    return ".\(MetricNumberRange.weightDecimalRange[row])"
                case 2:
                    return "kg"
                default:
                    return nil
                }
            }
        case .heightInput:
            if measurementSystem == .imperial {
                switch component {
                case 0:
                    return String(ImperialNumberRange.heightInFeetRange[row])
                case 1:
                    return "ft"
                case 2:
                    return "\(ImperialNumberRange.heightInInchesRange[row])"
                case 3:
                    return "in"
                default:
                    return nil
                }
            } else if measurementSystem == .metric {
                switch component {
                case 0:
                    return String(MetricNumberRange.heightInMeterRange)
                case 1:
                    return "m"
                case 2:
                    return "\(MetricNumberRange.heightInCentimeterRange[row])"
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
        switch inputType {
        case .weightInput:
            if measurementSystem == .imperial {
                switch component {
                case 0:
                    weightInLbsWholeNumber = ImperialNumberRange.weightWholeNumberRange[row]
                case 1:
                    weightInLbsDecimal = ImperialNumberRange.weightDecimalRange[row]
                default:
                    break
                }
            } else if measurementSystem == .metric {
                switch component {
                case 0:
                    weightInKgWholeNumber = MetricNumberRange.weightWholeNumberRange[row]
                case 1:
                    weightInKgDecimal = MetricNumberRange.weightDecimalRange[row]
                default:
                    break
                }
            }
        case .heightInput:
            if measurementSystem == .imperial {
                switch component {
                case 0:
                    heightInFt = ImperialNumberRange.heightInFeetRange[row]
                case 2:
                    heightInInches = ImperialNumberRange.heightInInchesRange[row]
                default:
                    break
                }
            } else if measurementSystem == .metric {
                switch component {
                case 0:
                    heightInMeter = MetricNumberRange.heightInMeterRange
                case 2:
                    heightInCentimeter = MetricNumberRange.heightInCentimeterRange[row]
                default:
                    break
                }
            }
            
        case .none:
            break
        }
        // save user input
        saveUserInput()
        
        updateUI()
    }
    
    // MARK: - pickerView Datasource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return inputType == .weightInput ? 3 : 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch inputType {
        case .weightInput:
            if measurementSystem == .imperial {
                switch component {
                case 0:
                    return ImperialNumberRange.weightWholeNumberRange.count
                case 1:
                    return ImperialNumberRange.weightDecimalRange.count
                case 2:
                    return 1
                default:
                    return 1
                }
            } else if measurementSystem == .metric {
                switch component {
                case 0:
                    return MetricNumberRange.weightWholeNumberRange.count
                case 1:
                    return MetricNumberRange.weightDecimalRange.count
                case 2:
                    return 1
                default:
                    return 1
                }
            }
        case .heightInput:
            if measurementSystem == .imperial {
                switch component {
                case 0:
                    return ImperialNumberRange.heightInFeetRange.count
                case 1:
                    return 1
                case 2:
                    return ImperialNumberRange.heightInInchesRange.count
                default:
                    return 1
                }
            } else if measurementSystem == .metric {
                switch component {
                case 0:
                    return 1
                case 1:
                    return 1
                case 2:
                    return MetricNumberRange.heightInCentimeterRange.count
                default:
                    return 1
                }
            }
        case .none:
            return 1
        }
        
        return 1
    }
    
    // MARK: - SegmentedControl
    @IBAction func segmentedControlTouched(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            measurementSystem = .imperial
        case 1:
            measurementSystem = .metric
        default:
            break
        }
        
        updateUI()
        
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
    
    var fileURL: URL?
    var fm = FileManager.default
    
    struct ArchiveKey {
        static let weight = "weight"
    }
    
    func buildFileURL() -> URL? {
        var fileURL: URL?
        
        do {
            // build path to application support directory
            let appSupportDirectory = try fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            // build path to custom app directory
            let bundleID = Bundle.main.bundleIdentifier ?? "BMICalculator"
            let appDirectoryURL = appSupportDirectory.appendingPathComponent(bundleID, isDirectory: true)
            // create directory
            do {
                try fm.createDirectory(at: appDirectoryURL, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                if error.code != NSFileWriteFileExistsError {
                    print("error:  \(error.domain) \(error.description)")
                }
            }
            // Build path to file
            fileURL = appDirectoryURL.appendingPathComponent("data").appendingPathExtension("plist")
        } catch let error as NSError {
            print("error: \(error.domain) \(error.description)")
        }
        return fileURL
    }
    
    /// Saves data to file
    func saveUserInput() {
        // Build path to file if it doesn't exist already
        if fileURL == nil {
            fileURL = buildFileURL()
        }
        
        // prepare data to be archived
        let jsonEncoder = JSONEncoder()
        userInput = UserInput(weightInLbs: weightInLbs, heightInInches: totalHeightInches)
        let inputData = try! jsonEncoder.encode(userInput!)
        
        // archive data in background thread
        if let fileURL = fileURL {
            do {
                try inputData.write(to: fileURL)
                
                // check to make sure the file was created/written
                if let fileAttributes = try? self.fm.attributesOfItem(atPath: fileURL.path) {
                    let creationDate = fileAttributes[FileAttributeKey.creationDate]
                    let modificationDate = fileAttributes[FileAttributeKey.modificationDate]
                    print("file created: \(creationDate!) modified: \(modificationDate!)")
                }
            } catch let error as NSError {
                print("error: \(error.domain)")
            }
        }
    }
    
    func loadUserInput() {
        // build URL to file
        fileURL = buildFileURL()
        
        // load data from URL
        if let url = fileURL {
            do {
                let weightData = try Data(contentsOf: url)
                let jsonDecoder = JSONDecoder()
                userInput = try! jsonDecoder.decode(UserInput.self, from: weightData)
                weightInLbs = userInput!.weightInLbs
                totalHeightInches = userInput!.heightInInches
            } catch let error as NSError {
                print("error: \(error.domain) \(error.description)")
            }
        } else {
            print("file url not available")
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

