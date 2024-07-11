//
//  ViewController.swift
//  Seven App UIKit
//
//  Created by Aldrei Glenn Nuqui on 7/11/24.
//

import UIKit
import SnapKit

class UserLoginVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    @objc func loginUser() {
        let isAllFieldsEmpty = checkAllFieldsEmpty()
        guard !isAllFieldsEmpty else {
            self.presentSSAlertOnMainThread(title: "Invalid", message: "Please enter username and password", buttonTitle: "Ok")
            return
        }
        
        showLoadingView()
        
        NetworkManager.shared.loginUser(username: usernameTextfield.text!, password: passwordTextfield.text!) { [weak self] result in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let authResponse):
                print("User logged in successfully \(authResponse.token)")
                NetworkManager.shared.setAuthResponse(authResponse)
                
                let welcomeVC = WelcomeVC()
                welcomeVC.authResponse = authResponse
                welcomeVC.username = self.usernameTextfield.text
                self.navigationController?.pushViewController(welcomeVC, animated: true)
                
                self.resetField()
            case .failure(let error):
                print(error)
                self.presentSSAlertOnMainThread(title: "Invalid", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func checkAllFieldsEmpty() -> Bool {
        // Check if all fields are empty
        let username = usernameTextfield.text ?? ""
        let password = passwordTextfield.text ?? ""
        
        // Return true if all fields are empty, false otherwise
        return username.isEmpty || password.isEmpty
    }
    
    func resetField() {
        usernameTextfield.text = ""
        passwordTextfield.text = ""
    }
    
    @objc func goRegister() {
        let registerVC = RegisterVC()
        navigationController?.pushViewController(registerVC, animated: true)
    }
 
    ///Mark: Setup UI
    func setUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.backgroundColor = .systemBackground
        
        let padding: CGFloat = 50
        
        view.addSubview(loginLabel)
        loginLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(140)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        view.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(padding)
        }
        
        view.addSubview(usernameTextfield)
        usernameTextfield.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
        }
   
        view.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameTextfield.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(padding)
        }
        
        view.addSubview(passwordTextfield)
        passwordTextfield.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
        }
        
        view.addSubview(buttonLogin)
        buttonLogin.snp.makeConstraints { make in
            make.top.equalTo(passwordTextfield.snp.bottom).offset(30)
            make.height.equalTo(50)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
        }
        
        view.addSubview(createAccountLabel)
        createAccountLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonLogin.snp.bottom).offset(30)
            make.centerX.equalTo(buttonLogin)
        }
    }
    
    lazy var loginLabel: SSTitleLabel = {
        let loginLabel = SSTitleLabel(textAlignment: .center, fontSize: 30)
        loginLabel.text = "User Login"
        loginLabel.textColor = .systemBlue
        return loginLabel
    }()
    
    lazy var usernameLabel: SSTitleLabel = {
        let usernameLabel = SSTitleLabel(textAlignment: .center, fontSize: 18)
        usernameLabel.text = "Username"
        return usernameLabel
    }()
    
    lazy var usernameTextfield: SSTextField = {
        let usernameTextfield = SSTextField(underLineColor: .secondaryLabel)
        usernameTextfield.placeholder = "please enter a username"
        return usernameTextfield
    }()
    
    lazy var passwordLabel: SSTitleLabel = {
        let passwordLabel = SSTitleLabel(textAlignment: .center, fontSize: 18)
        passwordLabel.text = "Password"
        return passwordLabel
    }()
    
    lazy var passwordTextfield: SSTextField = {
        let passwordTextFieldTextField = SSTextField(underLineColor: .secondaryLabel)
        passwordTextFieldTextField.placeholder = "please enter your password"
        passwordTextFieldTextField.isSecureTextEntry = true
        return passwordTextFieldTextField
    }()
    
    lazy var buttonLogin: SSButton = {
        let buttonLogin = SSButton(backgroundColor: .white, title: "LOG IN")
        buttonLogin.addTarget(self, action: #selector(loginUser), for: .touchUpInside)
        return buttonLogin
    }()
    
    lazy var createAccountLabel: SSTitleLabel = {
        let createAccountLabel = SSTitleLabel(textAlignment: .center, fontSize: 18)
        createAccountLabel.text = "Create an account"
        createAccountLabel.textColor = .systemRed
        createAccountLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(goRegister))
        createAccountLabel.addGestureRecognizer(tap)
        return createAccountLabel
    }()
}

