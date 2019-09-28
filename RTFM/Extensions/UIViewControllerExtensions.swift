//
//  UIViewControllerExtensions.swift
//  RTFM
//
//  Created by Евгений Богомолов on 09/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol UIViewControllerNavigationStyle {
    var largeTitleAttributes: [NSAttributedString.Key : Any]? { get }
    var navigationBarBackgroundImage: UIImage? { get }
    var navigationBarTintColor: UIColor? { get }
}

extension UIViewController: UIViewControllerNavigationStyle {
    @objc var largeTitleAttributes: [NSAttributedString.Key : Any]? {
        return [.foregroundColor: UIColor.black]
    }
    
    @objc var navigationBarBackgroundImage: UIImage? {
        return nil
    }
    
    @objc var navigationBarTintColor: UIColor? {
        return nil
    }
}

extension UIViewController {
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

protocol ActivityIndicating {
    func startAnimating()
    func stopAnimating()
    func isAnimating() -> Bool
}

extension UIViewController {
    
    @discardableResult
    func showHUD(text: String, duration: TimeInterval) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .text
        hud.label.text = text
        delay(duration) {
            hud.hide(animated: true)
        }
        return hud
    }
    
    func showLoadingHUD() -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        return hud
    }
  
}
