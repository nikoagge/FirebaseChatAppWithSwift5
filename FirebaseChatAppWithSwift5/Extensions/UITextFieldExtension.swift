//
//  UITextFieldExtension.swift
//  FirebaseChatAppWithSwift5
//
//  Created by Nikolas Aggelidis on 6/12/20.
//  Copyright © 2020 NAPPS. All rights reserved.
//

import UIKit

extension UITextField {
    func customSetup(isSecureTextEntry: Bool) {
        self.layer.cornerRadius = 13
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: 0))
        self.leftViewMode = .always
        self.isSecureTextEntry = isSecureTextEntry ? true : false
    }
}
