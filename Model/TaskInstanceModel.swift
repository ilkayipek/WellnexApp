//
//  TaskInstances.swift
//  WellnexApp
//
//  Created by MacBook on 20.05.2025.
//

import Foundation

struct TaskInstanceModel: FirebaseIdentifiable {
    var id: String
    var patientId: String
    var taskId: String
    var measureTypeId: String
    var isCompleted: Bool
    var slot: String
    var slotStart: String           // Örn: "18:00"
    var slotEnd: String             // Örn: "22:00"
    var scheduledDate: Date?
    var date: Date?
    var createdAt: Date?
    var measureTypeModel: MeasurementModel?
    var value: Double?
    var assignedBy: String?

    // Görev şu anda geçerli saat aralığında mı?
    var isInProgress: Bool {
        guard
              let start = slotStartAsDate,
              let end = slotEndAsDate else { return false }

        let now = Date()
        return now >= start && now <= end
    }

    // Görev zamanı henüz gelmediyse (yaklaşan)
    var isUpcoming: Bool {
        guard !isCompleted,
              let start = slotStartAsDate else { return false }
        return Date() < start
    }

    // Görev saati geçti ama tamamlanmadıysa (geçmiş)
    var isOverdue: Bool {
        guard !isCompleted,
              let end = slotEndAsDate else { return false }
        return Date() > end
    }

    // Tamamlanmış görev
    var isDone: Bool {
        isCompleted
    }

    var slotStartAsDate: Date? {
        return timeComponentAsDate(from: slotStart)
    }

    var slotEndAsDate: Date? {
        return timeComponentAsDate(from: slotEnd)
    }

    // Ortak tarih oluşturucu (slot saatini aynı günle birleştirir)
    private func timeComponentAsDate(from timeString: String) -> Date? {
        guard let baseDate = scheduledDate else { return nil }

        let components = timeString.split(separator: ":").compactMap { Int($0) }
        guard components.count == 2 else { return nil }

        let calendar = Calendar.current
        return calendar.date(bySettingHour: components[0], minute: components[1], second: 0, of: baseDate)
    }
}

