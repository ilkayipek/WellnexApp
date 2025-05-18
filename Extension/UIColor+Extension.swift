//
//  UIColor+Extension.swift
//  WellnexApp
//
//  Created by MacBook on 15.05.2025.
//

import UIKit

extension UIColor {
    static var activePrimaryButtonColor: UIColor {
        return UIColor(named: "activePrimaryButtonColor") ?? .green
    }
    
    static var activeSecondaryButtonColor: UIColor {
        return UIColor(named: "activeSecondaryButtonColor") ?? .blue
    }
    
    static var primaryLabelColor: UIColor {
        return UIColor(named: "primaryLabelColor") ?? .green
    }
    
    static var primaryTextFieldBackgroundColor: UIColor {
        return UIColor(named: "primaryTextFieldBackgroundColor") ?? .green
    }
}
