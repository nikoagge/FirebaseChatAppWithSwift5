//
//  LoginViewController.swift
//  FirebaseChatAppWithSwift5
//
//  Created by Nikolas Aggelidis on 5/12/20.
//  Copyright © 2020 NAPPS. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, Coordinator {
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
    }
    
    @IBAction func loginButtonTouchUpInside(_ sender: UIButton) {
        emailAddressTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let emailAddress = emailAddressTextField.text, let password = passwordTextField.text, !emailAddress.isEmpty, !password.isEmpty else {
            showAlertController(message: "Please fill all fields in order to login.")
            
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: emailAddress, password: password) { [weak self] (authDataResult, error) in
            guard let self = self else { return }
            guard let authDataResult = authDataResult, error == nil else {
                debugPrint("Failed to log in user with email address: \(emailAddress)")
                
                return
            }
            
            debugPrint("\(authDataResult.user) logged in.")
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupNavigationBar() {
        title = "Login"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(registerButtonTapped))
    }
    
    private func setupViews() {
        emailAddressTextField.customSetup(isSecureTextEntry: false)
        emailAddressTextField.delegate = self
        passwordTextField.customSetup(isSecureTextEntry: true)
        passwordTextField.delegate = self
        loginButton.customSetup()
    }
    
    @objc private func registerButtonTapped() {
        navigate(.init(page: .register, navigationStyle: .push(animated: true)))
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailAddressTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginButtonTouchUpInside(loginButton)
        }
        
        return true
    }
}
