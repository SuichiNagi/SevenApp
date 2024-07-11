//
//  WelcomeVC.swift
//  Seven App UIKit
//
//  Created by Aldrei Glenn Nuqui on 7/11/24.
//

import UIKit

class WelcomeVC: UIViewController {
    

    var authResponse: AuthResponse!
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        usernameLabel.text = username
    }
    
    @objc func logoutUser() {
        showLoadingView()
        
        NetworkManager.shared.logoutUser(token: authResponse.token) { [weak self] result in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let success):
                print(success)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print(error)
                self.presentSSAlertOnMainThread(title: "Invalid", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func setUI() {
        view.backgroundColor = .systemBackground
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-100)
            make.left.right.equalToSuperview()
        }
        
        view.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(welcomeLabel.snp.bottom).offset(15)
        }
        
        view.addSubview(buttonLogout)
        buttonLogout.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(30)
            make.height.equalTo(50)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
        }
    }

    
    lazy var welcomeLabel: SSTitleLabel = {
        let welcomeLabel = SSTitleLabel(textAlignment: .center, fontSize: 30)
        welcomeLabel.text = "Welcome to Home Page"
        welcomeLabel.textColor = .systemBrown
        return welcomeLabel
    }()
    
    lazy var usernameLabel: SSTitleLabel = {
        let usernameLabel = SSTitleLabel(textAlignment: .center, fontSize: 40)
        usernameLabel.textColor = .red
        return usernameLabel
    }()
    
    lazy var buttonLogout: SSButton = {
        let buttonLogout = SSButton(backgroundColor: .white, title: "LOG OUT")
        buttonLogout.addTarget(self, action: #selector(logoutUser), for: .touchUpInside)
        return buttonLogout
    }()
}
