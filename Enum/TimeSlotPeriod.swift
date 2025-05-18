//
//  HoursOfDayEnum.swift
//  WellnexApp
//
//  Created by MacBook on 15.05.2025.
//

enum TimeSlotPeriod: String, CaseIterable, Codable {
    case morning = "07:00-10:00"
    case afternoon = "12:00-15:00"
    case evening = "18:00-22:00"
    case night = "22:00-00:00"

    var startTime: String {
        switch self {
        case .morning: return "07:00"
        case .afternoon: return "12:00"
        case .evening: return "18:00"
        case .night: return "22:00"
        }
    }

    var endTime: String {
        switch self {
        case .morning: return "10:00"
        case .afternoon: return "15:00"
        case .evening: return "22:00"
        case .night: return "00:00"
        }
    }
}

