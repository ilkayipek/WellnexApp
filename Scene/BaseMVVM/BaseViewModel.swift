//
//  BaseViewModel.swift
//  WellnexApp
//
//  Created by MacBook on 16.04.2025.
//

import UIKit

class BaseViewModel {
    var loadingAnimationStart: ((String) -> Void)?
    var loadingAnimationStop: (() -> Void)?
    var successAnimation: ((String) -> Void)?
    var failAnimation: ((String) -> Void)?
    var alertMessage: ((_ alertTitle: String, _ alertMessage: String, _ actionTitle: String, _ handler: ((UIAlertAction) ->Void)? ) -> Void)?
    var gradientLoagingTabAnimation: CustomGradientLoadingAnimation?
}
