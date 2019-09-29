//
//  SettingsManager.swift
//  RTFM
//
//  Created by Евгений Богомолов on 29/09/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation

class SettingsManager {
    
    static let shared: SettingsManager = .init()
    
    var isMeasuringInBackgroundOn: Bool {
        get {
            if let value = self.get(forKey: "isMeasuringInBackgroundOn") as? Bool {
                return value
            }
            return false
        }
        set {
            self.set(value: newValue, forKey: "isMeasuringInBackgroundOn")
        }
    }
    var measuringTimeInterval: TimeInterval {
        get {
            if let value = self.get(forKey: "measuringTimeInterval") as? TimeInterval {
                return value
            }
            return 3600
        }
        set {
            self.set(value: newValue, forKey: "measuringTimeInterval")
        }
    }
    
    // MARK: - Private
    
    private init() {
        self.reloadSettings()
    }
    
    private var settings = [String: Any]()

    private let userDefaults: UserDefaults = {
        let defaults = UserDefaults.standard
        return defaults
    }()
    
    private func reloadSettings() {
        if let settings = self.userDefaults.dictionary(forKey: "Settings") {
            self.settings = settings
        } else {
            self.settings.removeAll()
        }
    }
    
    private func saveSettings() {
        self.userDefaults.set(self.settings, forKey: "Settings")
        self.userDefaults.synchronize()
    }
    
    private func get(forKey key: String) -> Any? {
        return self.settings[key]
    }
    
    private func set(value: Any, forKey key: String) {
        self.settings[key] = value
        self.saveSettings()
    }
    
    private func remove(forKey key: String) {
        self.settings.removeValue(forKey: key)
        self.saveSettings()
    }
}
