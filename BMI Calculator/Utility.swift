//
//  Utility.swift
//  BMI Calculator
//
//  Created by Peter Wu on 11/15/18.
//  Copyright © 2018 Peter Wu. All rights reserved.
//

import Foundation

// Keeps track of input mode and input context
class InputCoordinator {
    
    private (set)var mode: Mode
    private (set)var weightContext: MeasurementContext
    private (set)var heightContext: MeasurementContext
    private var activeInputContext: MeasurementContext?
    
    init() {
        mode = Mode.Viewing
        weightContext = MeasurementContext(measurement: .weight, system: .imperial)
        heightContext = MeasurementContext(measurement: .height, system: .imperial)
    }
    
    func currentInputContext() -> MeasurementContext? {
        return activeInputContext
    }
    
    func deactivateInput() {
        activeInputContext = nil
        mode = .Viewing
    }
    
    func activateWeightInput() {
        activeInputContext = weightContext
        mode = .Inputting
    }
    
    func activateHeightInput() {
        activeInputContext = heightContext
        mode = .Inputting
    }
    
    /// changes measurementSystem of active context based on index 
    func updateInputMeasurement(forIndex index: Int) {
        // update input measurement
        switch index {
        case 0:
            activeInputContext!.measurementSystem = .imperial
        case 1:
            activeInputContext!.measurementSystem = .metric
        default:
            break
        }
    }
    
    enum Mode {
        case Inputting
        case Viewing
    }
    
}

/// Context keeps track of the context of the measurement.  For example, a measurement of height in imperial system, or measurement of weight in metric system
class MeasurementContext {
    var bodyMeasurement: BodyMeasurement
    var measurementSystem: MeasurementSystem
    
    init(measurement: BodyMeasurement, system: MeasurementSystem) {
        bodyMeasurement = measurement
        measurementSystem = system
    }
    
    // MARK: Input State Management
    /// There are three mutually exclusive state.  Either the user is inputting weight, or inputting height, or simply viewing (none).  InputState enum
    /// encapsulates these mutually exclusive state.
    ///
    enum BodyMeasurement {
        case weight
        case height
    }
    
    /// Enum for categorizing two types of input.  An input is either metric or imperial system.
    ///
    /// - metric: represents metric system input
    /// - imperial: represents imperial system input
    enum MeasurementSystem: Int, Codable {
        case metric
        case imperial
    }
}

