//
//  UIImageView+Extension.swift
//  WellnexApp
//
//  Created by MacBook on 16.05.2025.
//

import UIKit

extension UIImageView {
    
    func loadImageFromAssets(_ name: AssetsImageName)  {
        self.image = UIImage(named: name.rawValue)
    }
}
