//
//  Utility.swift
//  BMI Calculator
//
//  Created by Peter Wu on 11/15/18.
//  Copyright © 2018 Peter Wu. All rights reserved.
//

import Foundation
import os.log

// Keeps track of input mode and input context
class InputCoordinator: NSObject, NSCoding {
    
    private (set)var mode: Mode
    private (set)var weightContext: MeasurementContext
    private (set)var heightContext: MeasurementContext
    private var activeInputContext: MeasurementContext?
    
    override init() {
        self.mode = Mode.Viewing
        self.weightContext = MeasurementContext(type: .weight, system: .imperial)
        self.heightContext = MeasurementContext(type: .height, system: .imperial)
    }
    
    required init?(coder: NSCoder) {
        if let mode = Mode(rawValue: coder.decodeInteger(forKey: InputCoordinatorCodingKeys.mode)),
            let weightContext = coder.decodeObject(forKey: InputCoordinatorCodingKeys.weightContext) as? MeasurementContext,
            let heightContext = coder.decodeObject(forKey: InputCoordinatorCodingKeys.heightCOntext) as? MeasurementContext {
            self.mode = mode
            self.weightContext = weightContext
            self.heightContext = heightContext
            self.activeInputContext = coder.decodeObject(forKey: InputCoordinatorCodingKeys.activeInputContext) as? MeasurementContext
        } else {
            return nil
        }
        
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(mode.rawValue, forKey: InputCoordinatorCodingKeys.mode)
        coder.encode(weightContext, forKey: InputCoordinatorCodingKeys.weightContext)
        coder.encode(heightContext, forKey: InputCoordinatorCodingKeys.heightCOntext)
        guard let activeContext = activeInputContext else { return }
        coder.encode(activeContext, forKey: InputCoordinatorCodingKeys.activeInputContext)
    }
    
    
    func currentInputContext() -> MeasurementContext? {
        return activeInputContext
    }
    
    func deactivateInput() {
        activeInputContext = nil
        mode = .Viewing
        saveInputContext()
    }
    
    func activateWeightInput() {
        activeInputContext = weightContext
        mode = .Inputting
        saveInputContext()
    }
    
    func activateHeightInput() {
        activeInputContext = heightContext
        mode = .Inputting
        saveInputContext()
    }
    
    /// changes measurementSystem of active context based on index 
    func updateInputMeasurement(forIndex index: Int) {
        // update input measurement
        switch index {
        case 0:
            activeInputContext!.system = .imperial
        case 1:
            activeInputContext!.system = .metric
        default:
            break
        }
        
        saveInputContext()
    }
    
    func saveInputContext() {
        
        //encode data
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: "inputCoordinator")
            os_log("InputContext saved")
        } catch {
            os_log("Unable to archive InputCoordinator")
        }
    }
    
    static func loadInputContext() -> InputCoordinator? {

        guard let data = UserDefaults.standard.data(forKey: "inputCoordinator") else {
            os_log("Unable to retrieve inputCoordinator data from userDefauls")
            return nil
        }
        
        do {
            let data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            
            if let inputCoordinator = data as? InputCoordinator {
                return inputCoordinator
            } else {
                return nil
            }
            
        } catch {
            os_log("Unable to unarchive InputCoordinator data")
            return nil
        }
    }
    
    enum Mode: Int {
        case Inputting = 1
        case Viewing = 2
    }
    
}

/// Context keeps track of the context of the measurement.  For example, a measurement of height in imperial system, or measurement of weight in metric system
class MeasurementContext: NSObject, NSCoding {
    
    var type: MeasurementType
    var system: MeasurementSystem
    
    init(type: MeasurementType, system: MeasurementSystem) {
        self.type = type
        self.system = system
    }
    
    required init?(coder: NSCoder) {
        if let type = MeasurementType(rawValue: coder.decodeInteger(forKey: MeasurementContextCodingKeys.type)),
            let system = MeasurementSystem(rawValue: coder.decodeInteger(forKey: MeasurementContextCodingKeys.system)) {
            self.type = type
            self.system = system
        } else {
            return nil
        }
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(type.rawValue, forKey: MeasurementContextCodingKeys.type)
        coder.encode(system.rawValue, forKey: MeasurementContextCodingKeys.system)
    }

    
    // MARK: Input State Management
    /// There are three mutually exclusive state.  Either the user is inputting weight, or inputting height, or simply viewing (none).  InputState enum
    /// encapsulates these mutually exclusive state.
    ///
    enum MeasurementType: Int {
        case weight = 1
        case height = 2
    }
    
    /// Enum for categorizing two types of input.  An input is either metric or imperial system.
    ///
    /// - metric: represents metric system input
    /// - imperial: represents imperial system input
    enum MeasurementSystem: Int {
        case metric = 1
        case imperial = 2
    }
}

struct MeasurementContextCodingKeys {
    static let type = "type"
    static let system = "system"
}

struct InputCoordinatorCodingKeys {
    static let mode = "mode"
    static let weightContext = "weightContext"
    static let heightCOntext = "heightContext"
    static let activeInputContext = "activeInputContext"
}

