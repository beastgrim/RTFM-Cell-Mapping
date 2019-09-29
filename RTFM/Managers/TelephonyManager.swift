//
//  TelephonyManager.swift
//  RTFM
//
//  Created by Евгений Богомолов on 27/09/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation
import CoreTelephony

enum RadioType {
    case gprs
    case edge
    case wcdma
    case hsdpa
    case hsupa
    case cdma1x
    case cdmaevdorev0
    case cdmaevdoreva
    case cdmaevdorevb
    case hrpd
    case lte
}

extension RadioType {
    var name: String {
        switch self {
        case .gprs:
            return "GPRS"
        case .edge:
            return "EDGE"
        case .wcdma:
            return "WCDMA"
        case .hsdpa:
            return "HSDPA"
        case .hsupa:
            return "HSUPA"
        case .cdma1x:
            return "CDMA_1X"
        case .cdmaevdorev0:
            return "CDMA_EVDO_REV_0"
        case .cdmaevdoreva:
            return "CDMA_EVDO_REV_A"
        case .cdmaevdorevb:
            return "CDMA_EVDO_REV_B"
        case .hrpd:
            return "HRPD"
        case .lte:
            return "LTE"
        }
    }
}

struct SignalInfo {
    let name: String
    let type: String
    let signalPower: Int
}

protocol TelephonyManagerObserverProtocol {
    func telephonyManager(_ manager: TelephonyManager, didChangeSignalPower: Int?)
}

class TelephonyManager: NSObject, ObjectObserversProtocol {
    typealias SelfClass = TelephonyManager
    typealias ProtocolClass = TelephonyManagerObserverProtocol
    
    static let shared: TelephonyManager = .init()
    private(set) var radioType: RadioType?
    private(set) var cellularProviders: [String : CTCarrier] = [:]
    private(set) var signalPower: Int?

    private override init() {
        self.networkInfo = .init()
        super.init()
        
//        if #available(iOS 13.0, *) {
//            self.networkInfo.delegate = self
//        }
        
        self.updateCellularProviders()
        self.updateRadioType()
        self.updateSignalPower()
        
        self.startRandomPower()

        NotificationCenter.default.addObserver(self, selector: #selector(radioTypeDidChange(_:)), name: NSNotification.Name.CTRadioAccessTechnologyDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func requestSignalInfo(_ completion: (SignalInfo?) -> Void) {
        self.updateSignalPower()
        self.updateCellularProviders()
        
        if let power = self.signalPower,
            let provider = self.cellularProviders.first?.value.carrierName?.uppercased(),
            let type = self.radioType {
            completion(.init(name: provider, type: type.name, signalPower: power))
        } else {
            completion(nil)
        }
    }
    
    private let networkInfo: CTTelephonyNetworkInfo
    
    private func updateCellularProviders() {
        let cellularProviders: [String : CTCarrier]
        if #available(iOS 12.0, *),
            let providers = self.networkInfo.serviceSubscriberCellularProviders {
            
            cellularProviders = providers
        } else if let provider = self.networkInfo.subscriberCellularProvider,
            let name = provider.carrierName {
            
            cellularProviders = [name: provider]
        } else {
            cellularProviders = [:]
        }
        self.cellularProviders = cellularProviders
        print("CellularProviders: \(self.cellularProviders)")
    }
    
    private func updateRadioType() {
        if let radioType = self.networkInfo.currentRadioAccessTechnology {
            switch radioType {
            case CTRadioAccessTechnologyLTE:
                self.radioType = .lte
            case CTRadioAccessTechnologyEdge:
                self.radioType = .edge
            case CTRadioAccessTechnologyGPRS:
                self.radioType = .gprs
            case CTRadioAccessTechnologyeHRPD:
                self.radioType = .hrpd
            case CTRadioAccessTechnologyHSDPA:
                self.radioType = .hsdpa
            case CTRadioAccessTechnologyHSUPA:
                self.radioType = .hsupa
            case CTRadioAccessTechnologyWCDMA:
                self.radioType = .wcdma
            case CTRadioAccessTechnologyCDMA1x:
                self.radioType = .cdma1x
            case CTRadioAccessTechnologyCDMAEVDORev0:
                self.radioType = .cdmaevdorev0
            case CTRadioAccessTechnologyCDMAEVDORevA:
                self.radioType = .cdmaevdoreva
            case CTRadioAccessTechnologyCDMAEVDORevB:
                self.radioType = .cdmaevdorevb
            default:
                self.radioType = nil
            }
        } else {
            self.radioType = nil
        }
        print("Radio type: \(String(describing: self.radioType))")
    }
    
    private func updateSignalPower() {
//        let libHandle = dlopen("/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony", RTLD_NOW)
//        let CTGetSignalStrength = dlsym(libHandle, "CTGetSignalStrength")
//
//        typealias CFunction = @convention(c) () -> Int
//
//        let power: Int?
//        if (CTGetSignalStrength != nil) {
//            let fun = unsafeBitCast(CTGetSignalStrength!, to: CFunction.self)
//            let result = fun()
//
//            power = result
//        } else {
//            power = nil
//        }
//        dlclose(libHandle)
        let power: Int?
        if #available(iOS 13.0, *) {
            power = getSignalStrength()
        } else {
            if let value = getSignalFromStatusBar() {
                power = value
            } else {
                power = getSignalFrom(networkInfo: self.networkInfo)
            }
        }
        
        if self.signalPower != power {
            self.signalPower = power
            
            self.callObservers { (manager, observer) in
                observer.telephonyManager(manager, didChangeSignalPower: power)
            }
        }
        print("Signal power: \(power ?? -1)")
    }
    
    
    // MARK: CTTelephonyNetworkInfoDelegate
    func dataServiceIdentifierDidChange(_ identifier: String) {
        print("\(#function) \(identifier)")
    }
    
    // MARK: Notifications
    @objc
    func radioTypeDidChange(_ note: Notification?) {
        self.updateRadioType()
    }
    
    // MARK: - Private
    private var timer: Timer?
    private func startRandomPower() {
        let timer = Timer.init(timeInterval: 1, repeats: true, block: { [weak self] (timer) in
            self?.updateSignalPower()
//            let power = Int(arc4random()%101)
//            self?.signalPower = power
//            self?.callObservers({ (manager, observer) in
//                observer.telephonyManager(manager, didChangeSignalPower: power)
//            })
        })
        RunLoop.main.add(timer, forMode: .default)
        self.timer = timer
    }
    
    private func stopRandomPower() {
        self.timer?.invalidate()
        self.timer = nil
    }
}
