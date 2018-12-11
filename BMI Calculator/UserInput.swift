//
//  UserData.swift
//  BMI Calculator
//
//  Created by Peter Wu on 11/14/18.
//  Copyright © 2018 Peter Wu. All rights reserved.
//

import Foundation

struct UserInput: Codable, CustomStringConvertible {
    var description: String {
        return "Imperial: \(weightInLbs) lbs \(totalHeightInInches) inches, Metric: \(weightInKgs) kgs, \(totalHeightInCm) cm"
    }
    
    
    var weightInLbs: Double
    var totalHeightInInches: Double
    var weightInKgs: Double
    var totalHeightInCm: Double
    
    init(weightInLbs: Double, heightInInches: Double, weightInKgs: Double, totalHeightInCm: Double) {
        self.weightInLbs = weightInLbs
        self.totalHeightInInches = heightInInches
        self.weightInKgs = weightInKgs
        self.totalHeightInCm = totalHeightInCm
    }
    
}
