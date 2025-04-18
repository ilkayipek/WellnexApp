//
//  Network.swift
//  WellnexApp
//
//  Created by MacBook on 17.04.2025.
//

import Firebase
import FirebaseFirestore

class Network {
    
    static let shared = Network()
    let database = Firestore.firestore()
    let firestore = Firestore.self
    
    private init() {
        let settings = FirestoreSettings()
        database.settings = settings
    }
    
}
