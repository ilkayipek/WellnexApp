//
//  SignUpViewController.swift
//  WellnexApp
//
//  Created by MacBook on 29.04.2025.
//

import UIKit

class SignUpViewController: BaseViewController<SignUpViewModel> {
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SignUpViewModel()
       
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
        let fullName = fullNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let passwordConf = passwordConfirmationTextField.text ?? ""
        
        
        viewModel?.signUp(fullName, email, password, passwordConf: passwordConf) { [weak self] status in
            guard let self else { return }
            
            self.successCreateAccount()
        }
        
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
    }
    
    func successCreateAccount() {
        
    }
}
