//
//  MeasurementModel.swift
//  WellnexApp
//
//  Created by MacBook on 16.05.2025.
//

struct MeasurementModel: FirebaseIdentifiable {
    var id: String
    var label: MeasureType?
    var description: String?
    var iconUrl: String?
    var unit: String?
    var minRecommended: Double?
    var maxRecommended: Double?
    var order: Int
}
