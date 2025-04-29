//
//  UserInfo.swift
//  WellnexApp
//
//  Created by MacBook on 29.04.2025.
//

import Foundation

class UserInfo {
    static let shared = UserInfo()
    
    private init() {}
    
    private var values = [UserInfoEnum: Any]()
    
    
    func retrieve<T>(key: UserInfoEnum) -> T? {
        return values[key] as? T
    }
    
    func store<T>(key: UserInfoEnum, value: T) {
        values[key] = value
    }
    
    func remove(key: UserInfoEnum) {
        values[key] = nil
    }
}
