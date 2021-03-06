//
//  ApiHostManager.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation
import Alamofire

class ApiHostManager {
    
    static let baseUrl: URL = URL(string: "https://scannet.ml/")!

    static let operationSession: SessionManager = {
        
        let configuration = URLSessionConfiguration.default
        
        let session = SessionManager(configuration: configuration)
        session.startRequestsImmediately = false
        
        return session
    }()
}
