//
//  UIButtonExtensions.swift
//  RTFM
//
//  Created by Евгений Богомолов on 28/09/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit

extension UIButton {
    
    class func makeSystemButton() -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = rgba(233, 233, 233, 0.2)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColorFromHex(rgbValue: 0x6979F8).cgColor
        
        button.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(165)
            make.height.equalTo(40)
        }
        return button
    }
}
