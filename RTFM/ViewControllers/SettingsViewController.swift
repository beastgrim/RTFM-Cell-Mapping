//
//  SettingsViewController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 29/09/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Настройки"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
