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
    var isVerified: Bool = false
    var createdAt: Date = Date()
    var updateAt: Date = Date()
    var fullName: String?
    var userType: String?
    var photoUrl: String?
}
