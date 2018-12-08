//
//  UserData.swift
//  BMI Calculator
//
//  Created by Peter Wu on 11/14/18.
//  Copyright © 2018 Peter Wu. All rights reserved.
//

import Foundation

struct UserInput: Codable {
    
    var weightInLbs: Double
    var totalHeightInInches: Double
    
    init(weightInLbs: Double, heightInInches: Double) {
        self.weightInLbs = weightInLbs
        self.totalHeightInInches = heightInInches
    }
    
}
