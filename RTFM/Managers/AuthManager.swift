//
//  AuthManager.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation

protocol AuthManagerObserverProtocol {
    func authManagerDidLogout(_ manager: AuthManager)
    func authManagerDidLogin(_ manager: AuthManager)
}

enum AuthManagerError: Error {
    case invalidCode
}

class AuthManager: ObjectObserversProtocol {
    typealias SelfClass = AuthManager
    typealias ProtocolClass = AuthManagerObserverProtocol
    
    static let shared: AuthManager = .init()
    
    var isAuthorized: Bool { return self.userId != 0 }
    
    private(set) var userToken: String = ""
    private(set) var userId: Int64 = 1
    
    func logout() {
        self.userId = 0
        self.callObservers { (manager, observer) in
            observer.authManagerDidLogout(manager)
        }
    }
    
    func login(phone: String, code: String,
               completion: @escaping (Error?) -> Void) {
        
        guard let userId = Int64(code) else {
            completion(AuthManagerError.invalidCode)
            return
        }
        self.userId = userId
        self.callObservers { (manager, observer) in
            observer.authManagerDidLogin(manager)
        }
        completion(nil)
    }
}
