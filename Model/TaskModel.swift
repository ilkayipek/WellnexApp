//
//  TaskModel.swift
//  WellnexApp
//
//  Created by MacBook on 16.05.2025.
//

import Foundation

struct TaskModel: FirebaseIdentifiable {
    var id: String
    let assignedBy: String
    let assignedTo: String
    let description: String
    let measureTypeId: String
    let patientId: String
    let doctorId: String
    let relationId: String
    let startDate: Date
    let endDate: Date
    let timeSlots: [String: [String]]
}



