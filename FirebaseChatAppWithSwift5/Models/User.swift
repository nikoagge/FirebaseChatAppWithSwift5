//
//  User.swift
//  FirebaseChatAppWithSwift5
//
//  Created by Nikolas Aggelidis on 19/12/20.
//  Copyright © 2020 NAPPS. All rights reserved.
//

import Foundation

struct User {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmailAddress: String {
        var se = emailAddress.replacingOccurrences(of: ".", with: "-")
        se = se.replacingOccurrences(of: "@", with: "-")
        
        return se
    }
}
