//
//  Untitled.swift
//  WellnexApp
//
//  Created by MacBook on 5.05.2025.
//

import Foundation

struct PatientDoctorRelationshipModel: FirebaseIdentifiable{
    var id: String
    var doctorId: String
    var patientId: String
    var patientName: String
    var doctorName: String
    var isActive: Bool
    var status: String
    var notes: String
    var createdAt: Date
    
    init(id: String, doctorId: String, patientId: String, patientName: String, doctorName: String, status: RelationshipStatus, note: String) {
        
        self.id = id
        self.doctorId = doctorId
        self.patientId = patientId
        self.patientName = patientName
        self.doctorName = doctorName
        self.isActive = false
        self.status = status.rawValue
        self.notes = note
        self.createdAt = Date()
    }
    
}
