//
//  Date+Extension.swift
//  WellnexApp
//
//  Created by MacBook on 23.05.2025.
//

import Foundation

extension Date {
    func getDayMonthYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
}
