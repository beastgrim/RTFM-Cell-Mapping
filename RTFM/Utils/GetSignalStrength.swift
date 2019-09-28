//
//  GetSignalStrength.swift
//  RTFM
//
//  Created by Евгений Богомолов on 28/09/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit
import CoreTelephony
import Darwin

func getSignalStrength() -> Int? {
    let result: Int32?
    //int CTGetSignalStrength();
    let libHandle = dlopen ("/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony", RTLD_LOCAL)
    let CTGetSignalStrength = dlsym(libHandle, "CTGetSignalStrength")
    
    typealias CFunction = @convention(c) () -> Int32
    
    if CTGetSignalStrength != nil {
        let fun = unsafeBitCast(CTGetSignalStrength!, to: CFunction.self)
        result = fun()
        print("!!!!result \(result!)")
    } else {
        result = nil
    }
    dlclose(libHandle)
    
    if let r = result {
        return Int(r)
    }
    return nil
 }

func getSignalFromStatusBar() -> Int? {
    let application = UIApplication.shared
    guard let statusBarView = application.value(forKey: "statusBar") as? UIView,
        let foregroundView = statusBarView.value(forKey: "foregroundView") as? UIView else {
        return nil
    }

    var dataNetworkItemView: UIView?
    for subview in foregroundView.subviews {
        let className = NSStringFromClass(subview.classForCoder)
//        print("Class: \(className)")
        if "UIStatusBarSignalStrengthItemView" == className {
            dataNetworkItemView = subview
            break;
        }
    }
    if let item = dataNetworkItemView {
        let number = (item.value(forKey: "signalStrengthBars") as? NSNumber)
        return number?.intValue
    }

    return nil
}

func getSignalFrom(networkInfo: CTTelephonyNetworkInfo) -> Int? {
    
    let selector = Selector("signalStrength")
    let value = networkInfo.perform(selector)?.takeRetainedValue()
    
//    let value = networkInfo.value(forKey: "signalStrength")
    print("Vla: \(String(describing: value))")
    return nil
}
