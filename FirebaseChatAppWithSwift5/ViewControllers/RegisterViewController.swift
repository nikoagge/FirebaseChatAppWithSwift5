//
//  RegisterViewController.swift
//  FirebaseChatAppWithSwift5
//
//  Created by Nikolas Aggelidis on 5/12/20.
//  Copyright © 2020 NAPPS. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
    }
    
    @IBAction func registerButtonTouchUpInside(_ sender: UIButton) {
        registerButtonTapped()
    }
    
    private func setupNavigationBar() {
        title = "Register"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(registerButtonTapped))
    }
    
    private func setupViews() {
        firstNameTextField.customSetup(isSecureTextEntry: false)
        firstNameTextField.delegate = self
        lastNameTextField.customSetup(isSecureTextEntry: false)
        lastNameTextField.delegate = self
        emailAddressTextField.customSetup(isSecureTextEntry: false)
        emailAddressTextField.delegate = self
        passwordTextField.customSetup(isSecureTextEntry: true)
        passwordTextField.delegate = self
        registerButton.customSetup()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profilePictureImageViewTapped))
        profilePictureImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func registerButtonTapped() {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailAddressTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let emailAddress = emailAddressTextField.text, let password = passwordTextField.text, !firstName.isEmpty, !lastName.isEmpty, !emailAddress.isEmpty, !password.isEmpty else {
            showAlertController(message: "Please fill all fields in order to register and create a new account.")
            
            return
        }
    }
    
    @objc private func profilePictureImageViewTapped() {
        debugPrint("profile picture tapped")
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailAddressTextField.becomeFirstResponder()
        } else if textField == emailAddressTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            registerButtonTouchUpInside(registerButton)
        }
        
        return true
    }
}
