//
//  ConversationsViewController.swift
//  FirebaseChatAppWithSwift5
//
//  Created by Nikolas Aggelidis on 5/12/20.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController, Coordinator {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        validateAuthentication()
    }
    
    private func validateAuthentication() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            navigate(.init(page: .login, navigationStyle: .presentWithNavigation(animated: true)))
        }
    }
}
