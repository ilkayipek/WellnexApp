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

//Get Methots
extension Network {
    
    func getOne<T: Decodable>(of type: T, with query: Query, completion: @escaping (Result<T, Error>) -> Void) {
        
        query.getDocuments { snapshot, error in
            
            if let error {
                print("Error: \(#function) couldn't access snapshot, \(error)")
                completion(.failure(error))
                return
            }
            
            guard let document = snapshot?.documents.first else {
                print("Warning: \(#function) document not found")
                completion(.failure(NetworkError.documentNotFound))
                return
            }
            
            do {
                let data = try document.data(as: T.self)
                completion(.success(data))
            } catch let error {
                print("Error: \(#function) document not decoded from data, \(error)")
                completion(.failure(error))
                return
            }
            
            
        }
    }
}
