//
//  ConversationsViewController.swift
//  FirebaseChatAppWithSwift5
//
//  Created by Nikolas Aggelidis on 5/12/20.
//

import UIKit

class ConversationsViewController: UIViewController, Coordinator {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserDefaultsManager.shared.isUserLoggedIn() {
            navigate(.init(page: .login, navigationStyle: .presentWithNavigation(animated: true)))
        }
    }
}
