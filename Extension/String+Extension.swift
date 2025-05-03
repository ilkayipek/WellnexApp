//
//  String+Extension.swift
//  WellnexApp
//
//  Created by MacBook on 3.05.2025.
//

extension String {
    func generateUsername(length: Int) -> Self {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numbers = "0123456789"
        let characters = letters + numbers
        
        var username = ""
        for _ in 0..<length {
            let randomIndex = Int.random(in: 0..<characters.count)
            let character = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            username.append(character)
        }
        
        return username
    }
}
