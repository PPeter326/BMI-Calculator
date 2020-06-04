//
//  BMICalculator.swift
//  BMI Calculator
//
//  Created by Peter Wu on 8/4/19.
//  Copyright © 2019 Peter Wu. All rights reserved.
//

import Foundation

enum BMICategory {
    
    case underweight, normalWeight, overweight, obesity
    
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
        }
    }
    
    static func category(of BMI: Double) -> BMICategory {
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
    private static let validHeightRangeInInches = 58.0...76.0
    
    /// Valid weight height ranges in lbs
    /// based on *Clinical Guidelines on the Identification, Evaluation, and Treatment of Overweight and Obesity in Adults: The Evidence Report.*
    private static let validWeightRangeInLbs = 91.0...443.0
}
