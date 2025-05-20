//
//  PatientHomeViewController.swift
//  WellnexApp
//
//  Created by MacBook on 20.05.2025.
//

import UIKit

class PatientHomeViewController: BaseViewController<PatientHomeViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = PatientHomeViewModel()
    }

}
