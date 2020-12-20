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
    
    func showActionSheet(title: String?, message: String?, actionTitles: [String], sourceView: UIView, completion: ((_ selection: String) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        for actionTitle in actionTitles {
            alertController.addAction(UIAlertAction(title: actionTitle, style: .default) { alertAction in
                completion?(actionTitle)
            })
        }
        alertController.popoverPresentationController?.sourceView = sourceView
        alertController.popoverPresentationController?.sourceRect = sourceView.bounds
        self.present(alertController, animated: true)
    }
}
