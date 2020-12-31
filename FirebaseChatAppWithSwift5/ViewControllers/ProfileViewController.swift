//
//  ProfileViewController.swift
//  FirebaseChatAppWithSwift5
//
//  Created by Nikolas Aggelidis on 5/12/20.
//  Copyright © 2020 NAPPS. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ProfileViewController: UIViewController, Coordinator {
    @IBOutlet weak var tableView: UITableView!
    
    let dataArray = ["testData"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = dataArray[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .green
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showActionSheet(title: "", message: "", actionTitles: ["Log Out"], sourceView: self.view) { [weak self] (_) in
            guard let self = self else { return }
            FBSDKLoginKit.LoginManager().logOut()
            
            GIDSignIn.sharedInstance()?.signOut()
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                self.navigate(.init(page: .login, navigationStyle: .present(animated: true)))
            } catch {
                debugPrint("Failed to log out.")
            }
        }
    }
}
