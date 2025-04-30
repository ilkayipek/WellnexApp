//
//  BaseViewController.swift
//  WellnexApp
//
//  Created by MacBook on 16.04.2025.
//

import UIKit
import ProgressHUD

class BaseViewController<V: BaseViewModel>: UIViewController {
    
    var pageTopLoadingAnimation: CustomGradientLoadingAnimation?
    
    var viewModel:V? {
        didSet {
            setViewModel()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func setViewModel() {
        setPageLoadingAnimation()
        
        viewModel?.loadingAnimationStart = { [weak self] text in
            guard let self else {return}
            self.loadingAnimationStart(text: text)
        }
        
        viewModel?.loadingAnimationStop = { [weak self] in
            guard let self else {return}
            self.loadingAnimationStop()
        }
        
        viewModel?.successAnimation = { [weak self] text in
            guard let self else {return}
            self.successAnimation(text: text)
        }
        
        viewModel?.failAnimation = { [weak self] text in
            guard let self else {return}
            self.failAnimation(text: text)
        }
        
        viewModel?.alertMessage = { [weak self] (alertMessage, alertTitle, actionTitle, actionHandler) in
            guard let self else {return}
            self.alertMessageDefault(alertTitle, alertMessage, actionTitle, actionHandler)
        }
    }
    
    func alertMessageDefault(_ alertTitle: String,_ alertMessage: String,_ actionTitle: String,_ handler: ((UIAlertAction) ->Void)? ) {
        
        let alertTitle = NSLocalizedString(alertTitle, comment: "")
        let alertMessage = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let actionTitle = NSLocalizedString(actionTitle, comment: "")
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel)
        let action = UIAlertAction(title: actionTitle, style: .destructive, handler: handler)
        
        alertMessage.addAction(cancelAction)
        alertMessage.addAction(action)
        present(alertMessage, animated: true)
    }
    
    func loadingAnimationStart(text: String) {
        ProgressHUD.animate(text, .circleStrokeSpin)
    }
    
    func loadingAnimationStop() {
        ProgressHUD.dismiss()
    }
    
    func successAnimation(text: String) {
        ProgressHUD.succeed(text,delay: 1.5)
    }
    
    func failAnimation(text: String) {
        ProgressHUD.failed(text)
    }
    
    func setPageLoadingAnimation() {
        
        self.pageTopLoadingAnimation = CustomGradientLoadingAnimation(x: 0, y: 0, width: view.frame.width*0.8, height: 5, color: UIColor(named: "DetailButtonBackgroundColor") ?? .black)
        viewModel?.gradientLoagingTabAnimation = self.pageTopLoadingAnimation
        
        self.navigationController?.navigationBar.addSubview(pageTopLoadingAnimation!)
    }

}
