//
//  RegisterViewController.swift
//  FirebaseChatAppWithSwift5
//
//  Created by Nikolas Aggelidis on 5/12/20.
//  Copyright © 2020 NAPPS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

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
        profilePictureImageView.layer.masksToBounds = true
        profilePictureImageView.fround(radius: profilePictureImageView.width/2)
    }
    
    @objc private func registerButtonTapped() {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailAddressTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let emailAddress = emailAddressTextField.text, let password = passwordTextField.text, !firstName.isEmpty, !lastName.isEmpty, !emailAddress.isEmpty, !password.isEmpty, password.count >= 6 else {
            showAlertController(message: "Please fill all fields in order to register and create a new account.")
            
            return
        }
        
        FirebaseAuth.Auth.auth().createUser(withEmail: emailAddress, password: password) { (authDataResult, error) in
            guard let authDataResult = authDataResult, error == nil else {
                debugPrint("Error creating user")
                
                return
            }
            
            debugPrint("\(authDataResult.user) user created.")
        }
    }
    
    @objc private func profilePictureImageViewTapped() {
        presentPhotoActionSheet()
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

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentPhotoActionSheet() {
        self.showActionSheet(title: "Profile Picture", message: "Select a picture for your profile", actionTitles: ["Take photo", "Choose photo"], sourceView: self.view) { [weak self] (actionTitle) in
            if actionTitle == "Take photo" {
                self?.presentImagePickerController(for: "Camera")
            } else if actionTitle == "Choose photo" {
                self?.presentImagePickerController(for: "PhotoLibrary")
            }
        }
    }
    
    func presentImagePickerController(for sourceType: String) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        if sourceType == "Camera" {
            imagePickerController.sourceType = .camera
        } else {
            imagePickerController.sourceType = .photoLibrary
        }
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        profilePictureImageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
