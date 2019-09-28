//
//  MainTabBarController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 28/09/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private(set) var centerLogoImageView: UIImageView!
    
    var measureViewController: MeasureViewController = {
        let controller = MeasureViewController()
        let icon = UIImage(named: "location")
        controller.tabBarItem = UITabBarItem(title: nil, image: icon, tag: 0)
        return controller
    }()
    
    var profileViewController: ProfileViewController = {
        let controller = ProfileViewController()
        let icon = UIImage(named: "profile")
        controller.tabBarItem = UITabBarItem(title: nil, image: icon, tag: 0)
        return controller
    }()
    
    var mapViewController: MapViewController = {
        let controller = MapViewController()
        let icon = UIImage(named: "map")
        controller.tabBarItem = UITabBarItem(title: nil, image: icon, tag: 0)
        return controller
    }()
    
    var settingsViewController: SettingsViewController = {
        let controller = SettingsViewController()
        let icon = UIImage(named: "settings")
        controller.tabBarItem = UITabBarItem(title: nil, image: icon, tag: 0)
        return controller
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)

        self.delegate = self
        
        let measureTab = UINavigationController(rootViewController: measureViewController)
        measureTab.setNavigationBarHidden(true, animated: false)
        let profileTab = UINavigationController(rootViewController: profileViewController)
        let mapTab = UINavigationController(rootViewController: mapViewController)
        mapTab.setNavigationBarHidden(true, animated: false)
        let settingsTab = UINavigationController(rootViewController: settingsViewController)
        let emptyTab = UIViewController()
        emptyTab.tabBarItem = UITabBarItem(title: nil, image: nil, tag: -1)
        self.viewControllers = [measureTab, mapTab, emptyTab, settingsTab, profileTab]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.tintColor = rgba(44, 83, 176, 0.7)
        
        let logoContentView = UIView()
        logoContentView.isUserInteractionEnabled = true
        logoContentView.backgroundColor = UIColorFromHex(rgbValue: 0x2C53B0)
        logoContentView.layer.cornerRadius = 32
        self.tabBar.addSubview(logoContentView)
        logoContentView.snp.makeConstraints { (make) in
            make.width.equalTo(64)
            make.height.equalTo(64)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.tabBar.snp.top).offset(-22)
        }
        
        let logo = UIImageView(image: UIImage(named: "tabbar-logo"))
        logo.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        logo.frame = logoContentView.bounds
        logoContentView.addSubview(logo)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return viewController.tabBarItem.tag != -1
    }
}
