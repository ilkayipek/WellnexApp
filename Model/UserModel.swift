//
//  User.swift
//  WellnexApp
//
//  Created by MacBook on 18.04.2025.
//

import Foundation

struct UserModel: FirebaseIdentifiable {
    
    var id: String
    var email: String
    var fullName: String
    var username: String
    var photoUrl: String?
    var userType: UserType
    var isVerified: Bool = false
    var createdAt: Date
    var updateAt: Date
    var fcmToken: String?
    
    
    init(id: String, email: String, fullName: String, userName: String, userType: UserType) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.username = userName
        self.userType = userType
        self.createdAt = Date()
        self.updateAt = Date()
    }
}
