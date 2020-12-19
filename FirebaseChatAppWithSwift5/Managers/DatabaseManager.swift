//
//  DatabaseManager.swift
//  FirebaseChatAppWithSwift5
//
//  Created by Nikolas Aggelidis on 19/12/20.
//  Copyright © 2020 NAPPS. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
    func checkIfUserExist(with emailAddress: String, completion: @escaping ((Bool) -> Void)) {
        var safeEmailAddress = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmailAddress = safeEmailAddress.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmailAddress).observeSingleEvent(of: .value) { (dataSnapshot) in
            guard dataSnapshot.value as? String != nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    func insertUser(with user: User) {
        database.child(user.safeEmailAddress).setValue([
            "firstName": user.firstName,
            "lastName": user.lastName 
        ])
    }
}
