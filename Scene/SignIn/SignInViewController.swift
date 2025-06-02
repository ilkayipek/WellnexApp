//
//  SignInViewController.swift
//  WellnexApp
//
//  Created by MacBook on 1.05.2025.
//

import UIKit

class SignInViewController: BaseViewController<SignInViewModel> {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SignInViewModel()
        addKeywordControl()
        
    }
    
    private func addKeywordControl() {
        
        let tapRec = UITapGestureRecognizer()
        tapRec.addTarget(self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tapRec)
        
    }
    
    @objc private func closeKeyboard() {
        view.endEditing(true)
    }

    @IBAction func signInTapped(_ sender: Any) {
        
        viewModel?.signIn(email: email.text ?? "", password: password.text ?? "") { [weak self] status in
            guard let self else {return}
            guard status else {return}
            
            self.signInSuceed()
        }
    }
   
    @IBAction func iForgetMyPasswordButtonTapped(_ sender: Any) {
        
        viewModel?.iForgetMyPassword(email: email.text ?? "")
    }
    
    private func signInSuceed() {
        guard let currentUsr: UserModel = UserInfo.shared.retrieve(key: .userModel) else {return}
        
        switch currentUsr.userType {
            
        case .doctor:
            let tabBar = DoctorTabBarController.loadFromNib()
            let navController = UINavigationController(rootViewController: tabBar)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
           
        case .patient:
            let targetVc = PatientTabBarController.loadFromNib()
            let newNavigationController = UINavigationController(rootViewController: targetVc)
            newNavigationController.modalPresentationStyle = .fullScreen
            self.present(newNavigationController, animated: true)
        }
        
        
    }
    @IBAction func SignUpButtonTapped(_ sender: Any) {
        
        let targerVc = SignUpViewController.loadFromNib()
        self.navigationController?.pushViewController(targerVc, animated: true)
    }
}
