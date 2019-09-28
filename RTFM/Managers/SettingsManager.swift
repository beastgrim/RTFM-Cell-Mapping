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
    var isMeasuringInBackgroundOn: Bool = false
    var measuringTimeInterval: TimeInterval = 3600 {
        didSet{print("\(self.measuringTimeInterval)")}
    }
    
    private init() {
        
    }
}
