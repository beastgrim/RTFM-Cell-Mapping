//
//  MainTabBarController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 28/09/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
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
    
    init() {
        super.init(nibName: nil, bundle: nil)

        let measureTab = UINavigationController(rootViewController: measureViewController)
        measureTab.setNavigationBarHidden(true, animated: false)
        let profileTab = UINavigationController(rootViewController: profileViewController)
        self.viewControllers = [measureTab, profileTab]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.tintColor = rgba(44, 83, 176, 0.7)
    }

}
