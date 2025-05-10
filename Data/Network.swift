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
    
    func refCreate(collection: FirebaseCollections,uid: String) -> DocumentReference {
        return database.collection(collection.rawValue).document(uid)
    }
    
}

//Get Methots
extension Network {
    
    // MARK: For Single Documents with query parameter
    func getOne<T: FirebaseIdentifiable>(of type: T.Type, with query: Query, completion: @escaping (Result<T, Error>) -> Void) {
        
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
    
    //MARK: For Multiple Documents with query parameter
    func getMany<T: Decodable>(of type: T.Type,
                               with query: Query,
                               completion: @escaping (Result<([T]), Error>) -> Void) {
        
        var decodeErrors: [Error] = []
        
        query.getDocuments { snapshot, error in
            
            if let error {
                print("Error: \(#function) couldn't access snapshot, \(error)")
                return
            }
            
            var responses: [T] = []
            
            guard let documents = snapshot?.documents else {
                print("Warning: \(#function) documents not found")
                completion(.success(responses))
                return
            }
            
            for document in documents {
                do {
                    let data = try document.data(as: T.self)
                    responses.append(data)
                } catch let error {
                    print("Decode failed for document: \(document.documentID), error: \(error)")
                    decodeErrors.append(error)
                }
            }
            
            print("Error: \(#function) documents not decoded from data, \(decodeErrors)")
            completion(.success(responses))
            
        }
    }
    
    //MARK: For Multiple Documents and paging
    func getMany<T: Decodable>(lastDoc: DocumentSnapshot? = nil, of type: T.Type, with query: Query, completion: @escaping (Result<([T], DocumentSnapshot?), Error>) -> Void) {
        
        var newQuery = query
        if let lastDoc {
            newQuery = newQuery.start(afterDocument: lastDoc)
        }
        
        newQuery.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error: couldn't access snapshot, \(error)")
                completion(.failure(error))
                return
            }
            
            var response: [T] = []
            guard let documents = querySnapshot?.documents else {
                completion(.success((response, nil)))
                return
            }
            
            for document in documents {
                do {
                    let data = try document.data(as: T.self)
                    response.append(data)
                } catch let error {
                    print("Error: \(#function) document(s) not decoded from data, \(error)")
                    completion(.failure(error))
                    return
                }
            }
            
            let lastDoc = documents.last
            completion(.success((response, lastDoc)))
        }
    }

    // MARK: for single document fetch with query parameter
    func getDocument<T: FirebaseIdentifiable>(reference: DocumentReference, completion: @escaping (Result<T, Error>) -> Void) {
        reference.getDocument { documentSnapshot, error in
            
            guard let data = try? documentSnapshot?.data(as: T.self) else {
                let error = NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode document"])
                completion(.failure(error))
                return
            }
            completion(.success(data))
        }
    }
}

// POST
extension Network {
    
    func post<T: FirebaseIdentifiable>(_ value: T, to collection: FirebaseCollections, completion: @escaping (Result<T, Error>) -> Void) {
        let valueToWrite: T = value
        let ref = database.collection(collection.rawValue).document(value.id)
        
        do {
            try ref.setData(from: valueToWrite) { error in
                if let error = error {
                    print("Error: \(#function) in collection: \(collection), \(error)")
                    completion(.failure(error))
                    return
                }
                completion(.success(valueToWrite))
            }
        } catch let error {
            print("Error: \(#function) in collection: \(collection), \(error)")
            completion(.failure(error))
        }
    }
    
    func put<T: FirebaseIdentifiable>(_ value: T, to collection: FirebaseCollections, completion: @escaping (Result<T, Error>) -> Void) {
        let ref = database.collection(collection.rawValue).document(value.id)
        do {
            try ref.setData(from: value) { error in
                if let error = error {
                    print("Error: \(#function) in \(collection) for id: \(value.id), \(error)")
                    completion(.failure(error))
                    return
                }
                completion(.success(value))
            }
        } catch let error {
            print("Error: \(#function) in \(collection) for id: \(value.id), \(error)")
            completion(.failure(error))
        }
    }
}

// DELETE
extension Network {
    
    func delete<T: FirebaseIdentifiable>(_ value: T, in collection: FirebaseCollections, completion: @escaping (Result<Void, Error>) -> Void) {
        let ref = database.collection(collection.rawValue).document(value.id)
        ref.delete { error in
            if let error = error {
                print("Error: \(#function) in \(collection) for id: \(value.id), \(error)")
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    func deleteMany<T: FirebaseIdentifiable>(of type: T.Type,with query: Query,_ completion: @escaping(Result<Void, any Error>) -> Void) {
        query.getDocuments { querySnapshot, error in
            if let error {
                print("Error:\(#function), \(error)")
                completion(.failure(error))
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Document is empty, \(#function)")
                let error = NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document is empty"])
                completion(.failure(error)); return
            }
            
            for document in documents {
                document.reference.delete()
            }
            
            completion(.success(()))
        }
    }
}




