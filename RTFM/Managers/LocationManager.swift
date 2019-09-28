//
//  LocationManager.swift
//  Weather
//
//  Created by Евгений Богомолов on 27/09/2019.
//  Copyright © 2019 be. All rights reserved.
//

import CoreLocation
import UIKit

enum LocationManagerError: Error, CustomNSError {
    case needAuthorizarion
    case denied
    case error(_: Error)
    case unknown(_: String)
    
    var errorUserInfo: [String : Any] {
        let desc: String
        switch self {
        case .needAuthorizarion:
            desc = "Autorization required"
        case .denied:
            desc = "Access denied"
        case .error(let err):
            desc = "Location error: \(err.localizedDescription)"
        case .unknown(let str):
            desc = str
        }
        return [NSLocalizedDescriptionKey: desc]
    }
}


class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared: LocationManager = .init()
    typealias CompletionBlock = (_: CLLocation?, _: LocationManagerError?)->Void

    var needAuthorizarion: Bool {
        return CLLocationManager.authorizationStatus() == .notDetermined
    }
    var canRequestLocation: Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedWhenInUse || status == .authorizedAlways
    }
    
    lazy private(set) var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    private var recentLocation: CLLocation?
    private var callbacks = [CompletionBlock]()
    private var appActiveObserver: NSObjectProtocol!
    
    // MARK: - Life
    
    private override init() {
        super.init()
        self.appActiveObserver = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (note) in
            
            if let manager = self, manager.canRequestLocation {
                manager.manager.requestLocation()
            }
        })
    }
    
    deinit {
        if let observer = self.appActiveObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    

    // MARK: - Public
    
    func requestLocation(completion: @escaping CompletionBlock) {
        
        if let location = recentLocation {
            completion(location, nil)
            return
        }
        
        callbacks.append(completion)
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            completion(nil, .denied)
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            completion(nil, .unknown("Unhandled case"))
        }
    }
    
    
    // MARK: - Private
    
    private func notify(location: CLLocation?, error: LocationManagerError?) {
        let callbacks = self.callbacks
        self.callbacks.removeAll()
        
        DispatchQueue.main.async {
            for block in callbacks {
                block(location, error)
            }
        }
    }

    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let mostRecentLocation = locations.last {
            recentLocation = mostRecentLocation
            notify(location: mostRecentLocation, error: nil)
        } else {
            notify(location: nil, error: .unknown("CLLocationManagerDelegate error"))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        notify(location: nil, error: .error(error))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .notDetermined: break
        default:
            notify(location: nil, error: .denied)
        }
    }
}
