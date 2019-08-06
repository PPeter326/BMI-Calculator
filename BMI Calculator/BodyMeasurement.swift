//
//  UserData.swift
//  BMI Calculator
//
//  Created by Peter Wu on 11/14/18.
//  Copyright © 2018 Peter Wu. All rights reserved.
//

import Foundation

// Model for height and weight

struct BodyMeasurement: Codable, CustomStringConvertible {
    
    var description: String {
        return "Imperial: \(weightInLbs.value) lbs \(totalHeightInInches.value) inches, Metric: \(weightInKgs.value) kgs, \(totalHeightInCm.value) cm"
    }
    
    var weightInLbs: Measurement<UnitMass>
    var totalHeightInInches: Measurement<UnitLength>
    var weightInKgs: Measurement<UnitMass>
    var totalHeightInCm: Measurement<UnitLength>
    
    init(weightInLbs: Measurement<UnitMass>, heightInInches: Measurement<UnitLength>, weightInKgs: Measurement<UnitMass>, totalHeightInCm: Measurement<UnitLength>) {
        self.weightInLbs = weightInLbs
        self.totalHeightInInches = heightInInches
        self.weightInKgs = weightInKgs
        self.totalHeightInCm = totalHeightInCm
    }
    
    
    /// Builds the url to the archived file location, which resides in the standard application document directory.  The file is named "measurement.plist".
    private static var archiveURL: URL = {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentDirectory.appendingPathComponent("measurement").appendingPathExtension("plist")
        return archiveURL
    }()
    
    /// Encodes measurement into Plist data file, and saves data file to archiveURL
    ///
    /// - Parameter measurement: Measurement struct, which is Codable
    static func saveToFile(measurement: BodyMeasurement) {
        // encode Measurement to data object
        // write data to archive url
        let propertyListEncoder = PropertyListEncoder()
        if let encodedMeasurement = try? propertyListEncoder.encode(measurement) {
            try? encodedMeasurement.write(to: archiveURL, options: .completeFileProtection)
        }
    }
    
    /// Retrieves data from archiveURL, then decode said data into Measurement struct using property list decoder
    ///
    /// - Returns: Measurement? could be nil if data could not be loaded, or if the data loaded could not be properly decoded using property list decoder
    static func loadFromFile() -> BodyMeasurement? {
        // create data from url
        // create Measurement object from data
        let propertyListDecoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: archiveURL), let measurement = try? propertyListDecoder.decode(BodyMeasurement.self, from: data) {
            return measurement
        } else {
            return nil
        }

    }

    /// Initializes a Measurement struct with predefined sample weight and height data
    ///
    /// - Returns: Measurement struct with predefined sample weight and height data
    static func loadSampleMeasurement() -> BodyMeasurement {
        let sampleMeasurement = BodyMeasurement(weightInLbs: Measurement(value: 170, unit: UnitMass.pounds), heightInInches: Measurement(value: 72, unit: UnitLength.inches), weightInKgs: Measurement(value: 83, unit: UnitMass.kilograms), totalHeightInCm: Measurement(value: 170, unit: UnitLength.centimeters))
        return sampleMeasurement
    }
    
}
