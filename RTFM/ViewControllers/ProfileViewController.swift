//
//  ProfileViewController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 28/09/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private(set) var bgImageView: UIImageView!
    private(set) var avaImageView: UIImageView!
    private(set) var nameLabel: UILabel!
    private(set) var phoneLabel: UILabel!
    private(set) var bonusLabel: UILabel!
    private(set) var useButton: UIButton!

    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Профиль"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(actionLogout(_:)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.bgImageView = UIImageView(image: UIImage(named: "profile-back"))
        self.bgImageView.contentMode = .scaleAspectFill
        self.view.addSubview(self.bgImageView)
        self.bgImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        self.avaImageView = UIImageView(image: UIImage(named: "ava-axample"))
        self.avaImageView.layer.cornerRadius = 60
        self.avaImageView.clipsToBounds = true
        self.view.addSubview(self.avaImageView)
        self.avaImageView.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(120)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(150)
        }
        
        self.nameLabel = UILabel()
        self.nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        self.nameLabel.textColor = .white
        self.nameLabel.text = "Маша Иванова"
        self.view.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(self.view.snp.left).offset(32)
            make.right.lessThanOrEqualTo(self.view.snp.right).offset(-32)
            make.top.equalTo(self.avaImageView.snp.bottom).offset(50)
        }
        
        self.phoneLabel = UILabel()
        self.phoneLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        self.phoneLabel.textColor = .white
        self.phoneLabel.text = "+7 945 835 82 56"
        self.view.addSubview(self.phoneLabel)
        self.phoneLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(16)
            make.left.greaterThanOrEqualTo(self.view.snp.left).offset(32)
            make.right.lessThanOrEqualTo(self.view.snp.right).offset(-32)
            make.centerX.equalToSuperview()
        }
        
        self.useButton = UIButton.makeSystemButton()
        self.useButton.setTitle("ИСПОЛЬЗОВАТЬ", for: .normal)
        self.useButton.addTarget(self, action: #selector(actionUseBonus(_:)), for: .touchUpInside)
        self.view.addSubview(self.useButton)
        self.useButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
        
        self.bonusLabel = UILabel()
        self.bonusLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        self.bonusLabel.textColor = rgba(43, 34, 118, 0.9)
        self.bonusLabel.text = "530 Б"
        self.view.addSubview(self.bonusLabel)
        self.bonusLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.useButton.snp.top).offset(-24)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc
    func actionUseBonus(_ sender: Any?) {
        // TODO: Show variants
    }
    
    @objc
    func actionLogout(_ sender: Any?) {
        AuthManager.shared.logout()
    }
}
