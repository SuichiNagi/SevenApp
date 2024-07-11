//
//  RegisterVC.swift
//  Seven App UIKit
//
//  Created by Aldrei Glenn Nuqui on 7/11/24.
//

import UIKit

class RegisterVC: UIViewController {
    
    let fontSize: CGFloat = 13
    
    var itemLabels: [UIView] = []
    var itemFields: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        resetField() //reset field every view will disappear
    }
    
    @objc func registerUser() {
        let isAllFieldsEmpty = checkAllFieldsEmpty()
        guard !isAllFieldsEmpty else {
            print("empty")
            presentSSAlertOnMainThread(title: "Invalid", message: "Please fill out the registration form completely", buttonTitle: "Ok")
            return
        }
        
        //check if email is valid
        guard emailTextfield.text!.isValidEmail else {
            print("invalid email")
            presentSSAlertOnMainThread(title: "Invalid Email", message: "Please input a valid email!", buttonTitle: "Ok")
            return
        }
        
        //check if password and repeat password match
        guard passwordTextfield.text == repeatPasswordTextfield.text else {
            print("invalid pass")
            presentSSAlertOnMainThread(title: "Invalid Password Match", message: "Input password not match!", buttonTitle: "Ok")
            return
        }
        
        showLoadingView()
        
        NetworkManager.shared.registerUser(username: usernameTextfield.text!, password: passwordTextfield.text!, email: emailTextfield.text!, name: fullnameTextfield.text!) { [weak self] result in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let authResponse):
                print(authResponse.token)
                self.presentSSAlertOnMainThread(title: "Succesful", message: "Account was successfully created!", buttonTitle: "Ok")
                resetField()
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print(error)
                self.presentSSAlertOnMainThread(title: "Invalid", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func resetField() {
        fullnameTextfield.text = ""
        usernameTextfield.text = ""
        emailTextfield.text = ""
        passwordTextfield.text = ""
        repeatPasswordTextfield.text = ""
    }
    
    func checkAllFieldsEmpty() -> Bool {
        // Check if all fields are empty
        let fullname = fullnameTextfield.text ?? ""
        let email = emailTextfield.text ?? ""
        let username = usernameTextfield.text ?? ""
        let password = passwordTextfield.text ?? ""
        let repeatPassword = repeatPasswordTextfield.text ?? ""
        
        // Return true if all fields are empty, false otherwise
        return fullname.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty || repeatPassword.isEmpty
    }

    func setUI() {
        view.backgroundColor = .systemBackground
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        let padding: CGFloat        = 50
        let topSpacing: CGFloat     = 10
        let bottomSpacing: CGFloat  = 30
        
        itemLabels = [fullnameLabel, emailLabel, usernameLabel, passwordLabel, repeatPasswordLabel]
        
        for itemLabel in itemLabels {
            view.addSubview(itemLabel)
            itemLabel.translatesAutoresizingMaskIntoConstraints = false
            
            itemLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(padding)
            }
        }
        
        itemFields = [fullnameTextfield, emailTextfield, usernameTextfield, passwordTextfield, repeatPasswordTextfield]
        
        for itemField in itemFields {
            view.addSubview(itemField)
            itemField.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(padding)
                make.right.equalToSuperview().offset(-padding)
                make.height.equalTo(40)
            }
        }
        
        view.addSubview(registerLabel)
        registerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
        }
        
        fullnameLabel.snp.makeConstraints { make in
            make.top.equalTo(registerLabel.snp.bottom).offset(bottomSpacing)
        }
        
        fullnameTextfield.snp.makeConstraints { make in
            make.top.equalTo(fullnameLabel.snp.bottom).offset(topSpacing)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(fullnameTextfield.snp.bottom).offset(bottomSpacing)
        }
        
        emailTextfield.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(topSpacing)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextfield.snp.bottom).offset(bottomSpacing)
        }
        
        usernameTextfield.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(topSpacing)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameTextfield.snp.bottom).offset(bottomSpacing)
        }
        
        passwordTextfield.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(topSpacing)
        }
        
        repeatPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextfield.snp.bottom).offset(bottomSpacing)
        }
        
        repeatPasswordTextfield.snp.makeConstraints { make in
            make.top.equalTo(repeatPasswordLabel.snp.bottom).offset(topSpacing)
        }
        
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(repeatPasswordTextfield.snp.bottom).offset(60)
            make.height.equalTo(50)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
        }
    }
    
    lazy var registerLabel: SSTitleLabel = {
        let registerLabel = SSTitleLabel(textAlignment: .center, fontSize: 30)
        registerLabel.text = "Create an Account"
        registerLabel.textColor = .systemRed
        return registerLabel
    }()
    
    lazy var fullnameLabel: SSTitleLabel = {
        let fullnameLabel = SSTitleLabel(textAlignment: .center, fontSize: fontSize)
        fullnameLabel.text = "Full Name"
        return fullnameLabel
    }()
    
    lazy var fullnameTextfield: SSTextField = {
        let fullnameTextfield = SSTextField(underLineColor: .secondaryLabel)
        fullnameTextfield.placeholder = "please enter your full name"
        return fullnameTextfield
    }()
    
    lazy var emailLabel: SSTitleLabel = {
        let emailLabel = SSTitleLabel(textAlignment: .center, fontSize: fontSize)
        emailLabel.text = "Email"
        return emailLabel
    }()
    
    lazy var emailTextfield: SSTextField = {
        let emailTextfield = SSTextField(underLineColor: .secondaryLabel)
        emailTextfield.delegate = self
        emailTextfield.placeholder = "please enter you email address"
        return emailTextfield
    }()
    
    lazy var usernameLabel: SSTitleLabel = {
        let usernameLabel = SSTitleLabel(textAlignment: .center, fontSize: fontSize)
        usernameLabel.text = "Username"
        return usernameLabel
    }()
    
    lazy var usernameTextfield: SSTextField = {
        let usernameTextfield = SSTextField(underLineColor: .secondaryLabel)
        usernameTextfield.placeholder = "please enter your username"
        return usernameTextfield
    }()
    
    lazy var passwordLabel: SSTitleLabel = {
        let passwordLabel = SSTitleLabel(textAlignment: .center, fontSize: fontSize)
        passwordLabel.text = "Password"
        return passwordLabel
    }()
    
    lazy var passwordTextfield: SSTextField = {
        let passwordTextfield = SSTextField(underLineColor: .secondaryLabel)
        passwordTextfield.placeholder = "please enter your password"
        passwordTextfield.isSecureTextEntry = true
        return passwordTextfield
    }()
    
    lazy var repeatPasswordLabel: SSTitleLabel = {
        let repeatPasswordLabel = SSTitleLabel(textAlignment: .center, fontSize: fontSize)
        repeatPasswordLabel.text = "Confirm password"
        return repeatPasswordLabel
    }()
    
    lazy var repeatPasswordTextfield: SSTextField = {
        let repeatPasswordTextfield = SSTextField(underLineColor: .secondaryLabel)
        repeatPasswordTextfield.placeholder = "please enter confirm password"
        repeatPasswordTextfield.isSecureTextEntry = true
        return repeatPasswordTextfield
    }()
    
    lazy var registerButton: SSButton = {
        let registerButton = SSButton(backgroundColor: .white, title: "SIGN UP")
        registerButton.addTarget(self, action: #selector(registerUser), for: .touchUpInside)
        return registerButton
    }()
}

extension RegisterVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let lowercaseString = string.lowercased()
        
        emailTextfield.text?.replaceSubrange(Range(range, in: textField.text!)!, with: lowercaseString)
        
        return false
    }
}
