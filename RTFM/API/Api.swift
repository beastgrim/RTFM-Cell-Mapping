//
//  Api.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation
import CocoaLumberjack

class Api {
    class func record(error: ApiRequestError) {
        // TODO:
    }
    
    class func addMeasure<T: ApiProtobufResponseModel<ApiSuccessEmptyResponse>>
        (host: String,
         userId: Int64,
         operatorName: String,
         radioType: String,
         signalPower: Double,
         latitude: Double,
         longitude: Double,
         successHandler: @escaping ((T) -> Void),
         failureHandler: @escaping ((ApiRequestError) -> Void)) -> ApiRequest<T> {
        
        var payload = AddMeasureRequest()
        payload.operatorName = operatorName
        payload.signal = signalPower
        payload.latitude = latitude
        payload.longitude = longitude
        payload.networkName = radioType
        
        print("AddMeasure: \(payload)")
        
        let request = ApiRequest(protobufToHost: host, path: "api/add_measure",
                                 uniqueType: "api/add_measure",
                                 protobufRequest: payload,
                                 successHandler: successHandler,
                                 failureHandler: { (error) in
                                    
                                    Api.record(error: error)
                                    failureHandler(error)
        })
        request.attemptWaitSeconds = 0
        request.maxAttempts = 1
        return request
    }
    
    class func cellHeatMap<T: ApiProtobufResponseModel<SignalMapResponse>>
        (host: String,
         leftBottom: CLLocationCoordinate2D,
         rightTop: CLLocationCoordinate2D,
         operatorName: String,
         radioType: String,
         successHandler: @escaping ((T) -> Void),
         failureHandler: @escaping ((ApiRequestError) -> Void)) -> ApiRequest<T> {
        
        var payload = SignalMapRequest()
        var lb = Point()
        lb.longitude = leftBottom.longitude
        lb.latitude = leftBottom.latitude
        var rt = Point()
        rt.longitude = rightTop.longitude
        rt.latitude = rightTop.latitude
        payload.borderPoints = [lb, rt]
        payload.operatorName = operatorName
        payload.networkName = radioType
        
        print("Get cell map: \(payload)")
        
        let request = ApiRequest(protobufToHost: host, path: "api/signal_map_proto",
                                 uniqueType: "api/signal_map_proto",
                                 protobufRequest: payload,
                                 successHandler: successHandler,
                                 failureHandler: { (error) in
                                    
                                    Api.record(error: error)
                                    failureHandler(error)
        })
        request.attemptWaitSeconds = 0
        request.maxAttempts = 1
        return request
    }
}
