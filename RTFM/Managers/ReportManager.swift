//
//  ReportManager.swift
//  RTFM
//
//  Created by Евгений Богомолов on 28/09/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation
import CoreLocation

enum ReportManagerError: Error {
    case locationNotAvailable
    case signalNotAvailable
    case networkError(ApiRequestError)
}

class ReportManager {
    
    static let shared: ReportManager = .init()
    var locationManager: LocationManager { return LocationManager.shared }
    var telephonyManager: TelephonyManager { return TelephonyManager.shared }
    
    private init() {
        
    }
    
    func report(_ completion: @escaping (Result<Void, ReportManagerError>) -> Void) {
        
        self.locationManager.requestLocation { (location, error) in
            if let location = location {
                self.telephonyManager.requestSignalInfo { (info) in
                    if let info = info {
                        self.reportRequest(location: location.coordinate, signal: info) { (error) in
                            if let err = error {
                                completion(.failure(.networkError(err)))
                            } else {
                                completion(.success(()))
                            }
                        }
                   
                    } else {
                        completion(.failure(.signalNotAvailable))
                    }
                }
            } else {
                completion(.failure(.locationNotAvailable))
            }
        }
    }
    
    private func reportRequest(location: CLLocationCoordinate2D,
                               signal: SignalInfo,
                               completion: @escaping (ApiRequestError?) -> Void) {
        
        let host = ApiHostManager.baseUrl.absoluteString
        let userId = AuthManager.shared.userId
        let power: Double = min(1.0, max(0.0, Double(signal.signalPower) / 100))
        
        let request = Api.addMeasure(host: host,
                                     userId: userId,
                                     operatorName: signal.name,
                                     radioType: signal.type,
                                     signalPower: power,
                                     latitude: location.latitude,
                                     longitude: location.longitude,
                                     successHandler: { (response) in
            completion(nil)
        }) { (error) in
            completion(error)
        }
        request.start()
    }
}
