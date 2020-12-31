//
//  AppDelegate.swift
//  FirebaseChatAppWithSwift5
//
//  Created by Nikolas Aggelidis on 5/12/20.
//  Copyright © 2020 NAPPS. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FBSDKCoreKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    var initialNavigationController: UINavigationController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            if let error = error {
                debugPrint("User failed to sign in with Google: \(error)")
            }
            
            return
        }
        guard let user = user else { return }
        
        debugPrint("User signed in with Google: \(user)")
        
        guard let googleEmailAddress = user.profile.email,
              let firstName = user.profile.givenName,
              let lastName = user.profile.familyName else { return }
        DatabaseManager.shared.checkIfUserExist(with: googleEmailAddress) { (userExists) in
            if !userExists {
                DatabaseManager.shared.insertUser(with: User(firstName: firstName, lastName: lastName, emailAddress: googleEmailAddress))
            }
        }
        
        guard let userAuthentication = user.authentication else {
            debugPrint("Missing authentication object off of google user.")
            
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: userAuthentication.idToken, accessToken: userAuthentication.accessToken)
        FirebaseAuth.Auth.auth().signIn(with: credential) { (authDataResult, error) in
            guard authDataResult != nil, error == nil else {
                debugPrint("Failed to log in with google credential.")
                
                return
            }
            
            debugPrint("Successfully signed in with Google credential.")
            
            NotificationCenter.default.post(name: .didLoginNotification, object: nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        debugPrint("Google user was disconnected.")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
