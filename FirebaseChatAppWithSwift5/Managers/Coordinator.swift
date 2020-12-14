//
//  Coordinator.swift
//  FirebaseChatAppWithSwift5
//
//  Created by Nikolas Aggelidis on 5/12/20.
//  Copyright © 2020 NAPPS. All rights reserved.
//

import UIKit

protocol Coordinator where Self: UIViewController {
    func navigate(_ navigationItem: NavigationItem)
}

enum StoryboardType: String {
    case conversations = "Conversations"
    case login = "Login"
    case register = "Register"
    case photoViewer = "PhotoViewer"
    case videoPlayer = "VideoPlayer"
    case newConversation = "NewConversation"
    case profile = "Profile"
    
    func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: nil)
    }
    
    func getController<T: UIViewController>(_ type: T.Type, setup: ((T) -> Void) = { _ in }) -> T? {
        if let viewController = self.getStoryboard().instantiateViewController(withIdentifier: String(describing: T.self)) as? T {
            setup(viewController)
            
            return viewController
        }
        
        return nil
    }
}

struct NavigationItem {
    enum PageType {
        case viewControllers(viewControllers: [UIViewController])
        case viewController(viewController: UIViewController)
        case conversations
        case login
        case register
        case photoViewer
        case videoPlayer
        case newConversation
        case profile
    }
    
    enum NavigationStyle {
        case present(animated: Bool)
        case presentWithNavigation(animated: Bool)
        case push(animated: Bool)
        case replace(animated: Bool)
        case setInitialNavigationRootControllers(animated: Bool)
    }
    
    let page: PageType
    let navigationStyle: NavigationStyle
}

extension Coordinator {
    func navigate(_ navigationItem: NavigationItem) {
        var controllerToNavigate: UIViewController!
        var controllersToInitialNavigation: [UIViewController] = []
        
        switch navigationItem.page {
        
        case .viewControllers(let viewControllers):
            controllersToInitialNavigation = viewControllers
            
        case .viewController(let viewController):
            controllerToNavigate = viewController
            
        case .conversations:
            controllerToNavigate = StoryboardType.conversations.getController(ConversationsViewController.self)
            
        case .login:
            controllerToNavigate = StoryboardType.login.getController(LoginViewController.self)
            
        case .register:
            controllerToNavigate = StoryboardType.register.getController(RegisterViewController.self)
            
        case .photoViewer:
            controllerToNavigate = StoryboardType.photoViewer.getController(PhotoViewerViewController.self)
            
        case .videoPlayer:
            controllerToNavigate = StoryboardType.videoPlayer.getController(VideoPlayerViewController.self)
            
        case .newConversation:
            controllerToNavigate = StoryboardType.newConversation.getController(NewConversationViewController.self)
            
        case .profile:
            controllerToNavigate = StoryboardType.profile.getController(ProfileViewController.self)
        }
        
        if let controllerToNavigate = controllerToNavigate {
            controllersToInitialNavigation.append(controllerToNavigate)
        }
        
        DispatchQueue.main.async {
            switch navigationItem.navigationStyle {
            
            case .present(let animated):
                self.present(controllerToNavigate, animated: animated)
                
            case .presentWithNavigation(let animated):
                let navigationController = UINavigationController(rootViewController: controllerToNavigate)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: animated)
                
            case .push(let animated):
                self.navigationController?.pushViewController(controllerToNavigate, animated: animated)
                
            case .replace(let animated):
                if var viewControllers = self.navigationController?.viewControllers {
                    viewControllers.removeLast()
                    viewControllers.append(controllerToNavigate)
                    self.navigationController?.setViewControllers(viewControllers, animated: animated)
                }
                
            case .setInitialNavigationRootControllers(let animated):
                Constants.appDelegate.initialNavigationController.setViewControllers(controllersToInitialNavigation, animated: animated)
            }
        }
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {}
