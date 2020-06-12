//
//  BMICalculator.swift
//  BMI Calculator
//
//  Created by Peter Wu on 8/4/19.
//  Copyright © 2019 Peter Wu. All rights reserved.
//

import Foundation

enum BMICategory {
    
    case underWeight, normalWeight, overWeight, obese
    
    func describe() -> String {
        switch self {
        case .underWeight:
            return "Underweight"
        case .normalWeight:
            return "Normal Weight"
        case .overWeight:
            return "Overweight"
        case .obese:
            return "Obese"
        }
    }
    
    static func category(of BMI: Double) -> BMICategory {
        switch BMI {
        case 0..<18.5:
            return .underWeight
        case 18.5..<25:
            return .normalWeight
        case 25..<30:
            return .overWeight
        case 30...:
            return .obese
        default:
            fatalError("BMICategory - invalid BMI") // should never happen
        }
    }
}

enum BMIError: Error {
    case invalidHeight, invalidWeight
}


/// Encapsulate calculation result and related BMI information provided by BMICalculator
struct BMIResult: CustomStringConvertible {
    var BMI: Double
    var category: BMICategory {
        return BMICategory.category(of: BMI)
    }
    
    var description: String {
        return """
        BMI: \(BMI), \
        \(category.describe())
        """
    }
}

class BMICalculator {

    
    /// The calculation does not assume validation of weight/height input and therefore returns error and result
    /// - Parameters:
    ///   - weight: in UnitMass
    ///   - height: in UnitLength
    /// - Returns: Error if weight and height are out of range
    final class func calculate(weight: Measurement<UnitMass>, height: Measurement<UnitLength>) -> (BMIError?, BMIResult?) {

        do {
            let BMI = try calculateBMI(weight: weight, height: height)
            let result = BMIResult(BMI: BMI)
            return (nil, result)
            
        } catch let error as BMIError {
            return (error, nil)
        } catch {
            print(error)
            fatalError("BMICalculator - Invalid error case")
        }
    }
    
    
    /// The calculation assume weight and height input are valid, and therefore only return result.  If inputs are invalid, the program will crash.
    /// - Parameters:
    ///   - weight: in UnitMass
    ///   - height: in UnitLength
    /// - Returns: BMI
    final class func calculate(weight: Measurement<UnitMass>, height: Measurement<UnitLength>) -> BMIResult {
        let BMI = try! calculateBMI(weight: weight, height: height) // Assume no error from calculation
        let result = BMIResult(BMI: BMI)
        return result
    }
    
    
    
    /// Calculates BMI based on weight in kg and height in meters.  The formula is BMI = kg / m^2
    /// Precondition: the values are within height and weight range established in NIH BMI table
    private class func calculateBMI(weight: Measurement<UnitMass>, height: Measurement<UnitLength> ) throws -> Double {
        
        guard let weight = validatedWeight(weight: weight)?.converted(to: UnitMass.kilograms) else { throw BMIError.invalidWeight }
        guard let heightInMeter = validatedHeight(height: height)?.converted(to: UnitLength.meters) else { throw BMIError.invalidHeight }
        return weight.value / (heightInMeter.value * heightInMeter.value)
    }
        
    private class func validatedWeight(weight: Measurement<UnitMass>) -> Measurement<UnitMass>? {
        return validWeightRangeInLbs.contains(weight.converted(to: UnitMass.pounds).value) ? weight : nil
    }
    
    private class func validatedHeight(height: Measurement<UnitLength>) -> Measurement<UnitLength>? {
        return validHeightRangeInInches.contains(height.converted(to: UnitLength.inches).value) ? height : nil
    }
    
    /// Valid height ranges in inches
    /// based on *Clinical Guidelines on the Identification, Evaluation, and Treatment of Overweight and Obesity in Adults: The Evidence Report.*
    static let validHeightRangeInInches = 57.0...83.0
    
    /// Valid weight height ranges in lbs
    /// based on *Clinical Guidelines on the Identification, Evaluation, and Treatment of Overweight and Obesity in Adults: The Evidence Report.*
    static let validWeightRangeInLbs = 91.0...443.0
}
