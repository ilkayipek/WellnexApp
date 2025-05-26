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
    
    func loadMeasureTypeImage(_ measureType: MeasureType)  {
        switch measureType {
        case .bloodSugar:
            loadImageFromAssets(.bloodSugar)
        case .pulse:
            loadImageFromAssets(.pulse)
        case .bodyTemperature:
            loadImageFromAssets(.bodyTemperature)
        case .bloodPressure:
            loadImageFromAssets(.bloodPressure)
        }
    }
}
