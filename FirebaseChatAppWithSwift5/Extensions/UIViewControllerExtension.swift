//
//  UIViewControllerExtension.swift
//  FirebaseChatAppWithSwift5
//
//  Created by Nikolas Aggelidis on 6/12/20.
//  Copyright © 2020 NAPPS. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertController(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}
