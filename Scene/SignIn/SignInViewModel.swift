//
//  SignIn.swift
//  WellnexApp
//
//  Created by MacBook on 1.05.2025.
//

import Foundation

class SignInViewModel: BaseViewModel {
    
    func signIn(email: String, password: String, closure: @escaping(Bool)->Void) {
        
        if checkIsEmptyPasswordAndEmail(email, password) {
            
            loadingAnimationStart?("")
            
            AuthManager.shared.signInWithEmail(email, password) { [weak self] status, error  in
                guard let self else {return}
                
                guard status else {
                    failAnimation?("\(error?.localizedDescription ?? "")")
                    closure(false); return
                }
                
                successAnimation?("Giriş Başarılı")
                closure(true)
            }
        }
    }
    
    private func checkIsEmptyPasswordAndEmail(_ email: String,_ password: String) -> Bool {
        guard email.isEmpty , password.isEmpty else {
            return true
        }
        
        failAnimation?("Boş Alan Bırakmayınız.")
        return false
    }
    
    private func checkEmail(_ email: String) -> Bool {
        guard !email.isEmpty else {
            failAnimation?("Email Alanı Boş Bıraklılamaz!")
            return false
        }
        
        if !isValidEmail(email: email) {
            failAnimation?("Geçerli Email Adresi Giriniz.")
            return false
        }
        
        return true
        
    }
    
    private func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func iForgetMyPassword(email: String) {
        
        if checkEmail(email) {
            AuthManager.shared.auth.sendPasswordReset(withEmail: email) {[weak self] error in
                guard let self else {return}
                
                guard error == nil else {
                    failAnimation?("Bir Hata Oluştu: \(String(describing: error?.localizedDescription))")
                    return
                }
                
                successAnimation?("email adresine sıfırlama linki gönderildi.")
                
            }
        }
    }
    
}
