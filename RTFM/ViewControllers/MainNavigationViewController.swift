//
//  MainNavigationViewController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setNavigationBarHidden(true, animated: false)

        let viewControllers: [UIViewController]
        if AuthManager.shared.isAuthorized {
            viewControllers = [MainTabBarController()]
        } else {
            let controller = LoginViewController()
            controller.completion = { [weak self] vc in
                self?.actionDidLogin()
            }
            viewControllers = [controller]
        }
        self.viewControllers = viewControllers
        
        AuthManager.shared.register(observer: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        AuthManager.shared.unregister(observer: self)
    }
    
    func actionDidLogin() {
        let mainController = MainTabBarController()
        self.setViewControllers([mainController], animated: true)
    }
    
    func actionDidLogout() {
        let controller = LoginViewController()
        controller.completion = { [weak self] vc in
            self?.actionDidLogin()
        }
        self.setViewControllers([controller], animated: true)
    }
}

extension MainNavigationViewController: AuthManagerObserverProtocol {
    func authManagerDidLogout(_ manager: AuthManager) {
        self.actionDidLogout()
    }
}
