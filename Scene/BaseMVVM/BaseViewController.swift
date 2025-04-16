//
//  BaseViewController.swift
//  WellnexApp
//
//  Created by MacBook on 16.04.2025.
//

import UIKit

class BaseViewController<V: BaseViewModel>: UIViewController {
    
    var viewModel:V? {
        didSet {
            setViewModel()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func setViewModel () {
        
    }

}
