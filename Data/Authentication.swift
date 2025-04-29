//
//  Authentication.swift
//  WellnexApp
//
//  Created by MacBook on 19.04.2025.

import FirebaseAuth
import Firebase

class AuthManager {
    static let shared = AuthManager()
    let auth = Auth.auth()
    let emailAuthProvider = EmailAuthProvider.self
    
    private init () {
        
    }
    
    func signUpWithEmail(_ fullName: String,_ email: String,_ password: String,_ closure: @escaping (Bool,Error?) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self else {return}
            
            if let user = result?.user{
                
                self.createUserDocs(firebaseUser: user, fullName: fullName) { status, error in
                    if status {
                        self.signInWithEmail(email, password, closure)
                    }
                }
                
            } else {
                closure(false,error)
            }
        }
    }
    
    func signInWithEmail(_ email: String,_ password: String,_ closure: @escaping (Bool,Error?) -> Void ) {
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self else {return}
            guard error == nil else {closure(false,error); return}
            guard let user = authResult?.user else {closure(false,error); return}
            
            self.getUserDocs(id: user.uid) { status, error in
                guard error == nil else {closure(false,error); return}
                guard status else {closure(false,nil); return}
                
                closure(true, nil)
            }
        }
    }
}

//MARK: User create documents
extension AuthManager {
    
    func createUserDocs(firebaseUser: User, fullName: String,_ completion: @escaping (Bool,Error?) -> Void) {
        let userModel = createUserModel(firebaseUser, fullName: fullName)
        
        createUserModelDoc(user: userModel, completion)
        
    }
    
    private func createUserModelDoc(user: UserModel, _ closure: @escaping (Bool,Error?) -> Void) {
        
        Network.shared.post(user, to: .users) { (result: Result<UserModel, any Error>) in
            switch result {
            case .success(let success):
                
                UserInfo.shared.store(key: .userModel, value: user)
                closure(true,nil)
            case .failure(let failure):
                
                closure(false, failure)
            }
        }
        
    }
}

//MARK: User get Documents
extension AuthManager {
    func getUserDocs(id: String, completion: @escaping (Bool,Error?) -> Void) {
        
        getUserModel(id: id, completion)
    }
    
    func getUserModel(id: String, _ completion: @escaping (Bool,Error?) -> Void) {
        
        let docRef = Network.shared.refCreate(collection: .users, uid: id)
        
        Network.shared.getDocument(reference: docRef) { (result: Result<UserModel, any Error>) in
            
            switch result {
            case .success(let user):
                
                UserInfo.shared.store(key: .userModel, value: user)
                completion(true, nil)
                
            case .failure(let failure):
                
                completion(false, failure)
            }
            
        }
    }
}

//MARK: models create functions
extension AuthManager {
    
    func createUserModel(_ firebaseUser: User, fullName: String) -> UserModel {
        
        let id = firebaseUser.uid
        let email = firebaseUser.email ?? ""
        let photoURLString = firebaseUser.photoURL?.absoluteString ?? ""
        let isVerified = firebaseUser.isEmailVerified
        let fullName = firebaseUser.displayName ?? fullName
        
        return UserModel(id: id, email: email, fullName: fullName, photoUrl: photoURLString)
    }
    
}

