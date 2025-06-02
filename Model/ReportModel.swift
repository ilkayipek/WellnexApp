//
//  ReportModel.swift
//  WellnexApp
//
//  Created by MacBook on 28.05.2025.
//

import Foundation


struct ReportModel: FirebaseIdentifiable {
    
    var id: String
    var taskId: String
    var patientId: String
    var doctorId: String
    
    var averageValue: Double?
    var completionRate: Int?
    
    var aboveRangeCount: Int?
    var belowRangeCount: Int?
    var inRangeCount: Int?
    
    var completedCount: Int?
    var expectedCount: Int?
    
    var highestValue: Double?
    var lowestValue: Double?
    
    var isComplete: Bool
    var createdAt = Date()
    
    var taskModel: TaskModel?
}
