//
//  UserData.swift
//  BMI Calculator
//
//  Created by Peter Wu on 11/14/18.
//  Copyright © 2018 Peter Wu. All rights reserved.
//

import Foundation

// Model for height and weight

struct Measurement: Codable, CustomStringConvertible {
    
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
    
    static var archiveURL: URL = {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentDirectory.appendingPathComponent("measurement").appendingPathExtension("plist")
        return archiveURL
    }()
    
    static let propertyListEncoder = PropertyListEncoder()
    
    static let propertyListDecoder = PropertyListDecoder()
    
    static func saveToFile(measurement: Measurement) {
        // build archive url to document directory
        // encode Measurement to data object
        // write data to archive url
        if let encodedMeasurement = try? propertyListEncoder.encode(measurement) {
            try? encodedMeasurement.write(to: archiveURL, options: .noFileProtection)
        }
    }
    
    static func loadFromFile() -> Measurement? {
        // build url to file
        // create data from url
        // create Measurement object from data
        if let data = try? Data(contentsOf: archiveURL), let measurement = try? propertyListDecoder.decode(Measurement.self, from: data) {
            return measurement
        } else {
            return nil
        }

    }

    static func loadSampleMeasurement() -> Measurement {
        let sampleMeasurement = Measurement(weightInLbs: 170, heightInInches: 72, weightInKgs: 83, totalHeightInCm: 170)
        return sampleMeasurement
    }
    
}
