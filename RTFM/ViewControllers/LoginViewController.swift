//
//  LoginViewController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 27/09/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: KeyboardViewController {
    
    private(set) var backgroundImageView: UIImageView!
    private(set) var logoImageView: UIImageView!
    private(set) var loginButton: UIButton!
    private(set) var textField: UITextField!
    private(set) var textFieldContentView: UIView!

    var completion: ((LoginViewController) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundImageView = UIImageView(image: UIImage(named: "splash"))
        self.backgroundImageView.contentMode = .scaleAspectFill
        self.view.addSubview(self.backgroundImageView)
        self.backgroundImageView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.logoImageView = UIImageView(image: UIImage(named: "lounch-icon"))
        self.logoImageView.contentMode = .scaleAspectFit
        self.view.addSubview(self.logoImageView)
        self.logoImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.height.equalToSuperview().dividedBy(3)
            make.width.equalToSuperview()
        }
        
        self.textFieldContentView = UIView()
        self.textFieldContentView.layer.cornerRadius = 6
        self.textFieldContentView.backgroundColor = .white
        self.view.addSubview(self.textFieldContentView)
        self.textFieldContentView.snp.makeConstraints { (make) in
            make.width.equalTo(240)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.logoImageView.snp.bottom).offset(80)
            make.height.equalTo(48)
        }
        
        self.textField = UITextField()
        self.textField.delegate = self
        self.textField.text = "+7"
        self.textField.textColor = .black
        self.textField.keyboardType = .phonePad
        self.textFieldContentView.addSubview(self.textField)
        self.textField.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.top.equalTo(14)
            make.bottom.equalTo(-14)
        }

        self.loginButton = UIButton.makeSystemButton()
        self.loginButton.setTitle("ВОЙТИ", for: .normal)
        self.loginButton.addTarget(self, action: #selector(actionLogin(_:)), for: .touchUpInside)
        self.view.addSubview(self.loginButton)
        self.loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.textFieldContentView.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ReportManager.shared.report { (result) in
            switch result {
                
            case .success:
                print("Success")
            case .failure(let err):
                print("Error: \(err)")
            }
        }
    }
    
    @objc
    func actionLogin(_ sender: Any?) {
        // TODO: connect to API
        self.completion?(self)
        self.completion = nil
    }

    override func animateKeyboardChange(_ beginFrame: CGRect, end endFrame: CGRect, intersection: CGRect) {
        if intersection.height > 0 {
            self.view.frame.origin.y -= intersection.height
        } else {
            self.view.frame.origin = .zero
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
