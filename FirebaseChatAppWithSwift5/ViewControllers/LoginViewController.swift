//
//  LoginViewController.swift
//  FirebaseChatAppWithSwift5
//
//  Created by Nikolas Aggelidis on 5/12/20.
//  Copyright © 2020 NAPPS. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController, Coordinator {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private let facebookLoginButton: FBLoginButton = {
        let flb = FBLoginButton()
        flb.permissions = ["email, public_profile"]
        
        return flb
    }()
    
    private let googleLoginButton = GIDSignInButton()
    private var loginObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didLoginNotification, object: nil, queue: nil) { [weak self] (_) in
            guard let self = self else { return }
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
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
        
        contentView.addSubview(facebookLoginButton)
        facebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
        facebookLoginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 30).isActive = true
        facebookLoginButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor).isActive = true
        facebookLoginButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor).isActive = true
        facebookLoginButton.heightAnchor.constraint(equalToConstant: 49).isActive = true
        facebookLoginButton.delegate = self
        
        contentView.addSubview(googleLoginButton)
        googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        googleLoginButton.topAnchor.constraint(equalTo: facebookLoginButton.bottomAnchor, constant: 30).isActive = true
        googleLoginButton.leadingAnchor.constraint(equalTo: facebookLoginButton.leadingAnchor).isActive = true
        googleLoginButton.trailingAnchor.constraint(equalTo: facebookLoginButton.trailingAnchor).isActive = true
        googleLoginButton.heightAnchor.constraint(equalToConstant: 49).isActive = true
        googleLoginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
    }
    
    deinit {
        if let loginObserver = loginObserver {
            NotificationCenter.default.removeObserver(loginObserver)
        }
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

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            debugPrint("User failed to log in with Facebook.")
            
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
        facebookRequest.start { (graphRequestConnection, result, error) in
            guard let result = result as? [String: Any], error == nil else {
                debugPrint("Failed to make Facebook Graph request")
                
                return
            }
            
            debugPrint(result)
            guard let userName = result["name"] as? String, let emailAddress = result["email"] as? String else {
                debugPrint("Failed to get userName and emailAddress from Facebook Graph result.")
                
                return
            }
            let userNameComponentsArray = userName.components(separatedBy: " ")
            guard userNameComponentsArray.count == 2 else { return }
            let firstName = userNameComponentsArray[0]
            let lastName = userNameComponentsArray[1]
            DatabaseManager.shared.checkIfUserExist(with: emailAddress) { (userExists) in
                if !userExists {
                    DatabaseManager.shared.insertUser(with: User(firstName: firstName, lastName: lastName, emailAddress: emailAddress))
                }
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] (authDataResult, error) in
                guard let self = self else { return }
                guard authDataResult != nil, error == nil else {
                    if let error = error {
                    debugPrint("Facebook credential login failed, MFA may be needed: \(error).")
                    }
                    return
                }
                
                debugPrint("User successfully logged in.")
                self.navigationController?.dismiss(animated: true)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    }
}
