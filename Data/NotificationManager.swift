//
//  NotificationManager.swift
//  WellnexApp
//
//  Created by MacBook on 21.05.2025.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init () {}
    
    func fetchAndScheduleLocalNotifications() {
        //guard let curentUsr: UserModel = UserInfo.shared.retrieve(key: .userModel) else {return}
        let usrId = "70tcDt3dzYYnMyb33h6f0BnIyQ53"
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // 📅 Bugün daha önce planlandı mı kontrol et
        let todayStr = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        let lastPlanned = UserDefaults.standard.string(forKey: "lastPlannedDate")
        
        guard lastPlanned != todayStr else {
            print("✅ Bugünün görevleri zaten planlandı.")
            return
        }
        
        let network = Network.shared
        let collection = network.database.collection(FirebaseCollections.taskInstances.rawValue)
        let query = collection.whereField("patientId", isEqualTo: usrId)
            .whereField("date", isGreaterThanOrEqualTo: startOfDay)
            .whereField("date", isLessThan: endOfDay)
        
        
        network.getMany(of: TaskInstanceModel.self, with: query) { [weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(let results):
                self.setNotifications(results)
            case .failure(let error):
                print("HATA: \(error.localizedDescription)")
                
                
            }
        }
    }
    
    private func setNotifications(_ results: [TaskInstanceModel]) {
        let now = Date()
        let todayStr = DateFormatter.localizedString(from: now, dateStyle: .short, timeStyle: .none)
        let center = UNUserNotificationCenter.current()
        
        for result in results {
            let taskId = result.id
            let slotStart = result.slotStart
            let slotEnd = result.slotEnd
            
            // 🔽 Ortak fonksiyon: "HH:mm" → Date
            func dateFor(time: String) -> Date? {
                let components = time.split(separator: ":")
                guard components.count == 2,
                      let hour = Int(components[0]),
                      let minute = Int(components[1]) else { return nil }
                
                var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: now)
                dateComponents.hour = hour
                dateComponents.minute = minute
                
                return Calendar.current.date(from: dateComponents)
            }
            
            guard let startDate = dateFor(time: slotStart),
                  let endDate = dateFor(time: slotEnd) else {
                continue
            }
            
            let startReminderDate = Calendar.current.date(byAdding: .minute, value: -15, to: startDate)!
            let endReminderDate = Calendar.current.date(byAdding: .minute, value: -15, to: endDate)!
            
            if startReminderDate > now {
                let startContent = UNMutableNotificationContent()
                startContent.title = "⏰ Görev Yaklaşıyor"
                startContent.body = "\(slotStart) saatinde ölçüm başlayacak. Hazırlanmayı unutma!"
                startContent.sound = .default

                let startComponents = Calendar.current.dateComponents([.hour, .minute], from: startReminderDate)
                let startTrigger = UNCalendarNotificationTrigger(dateMatching: startComponents, repeats: false)
                let startRequest = UNNotificationRequest(identifier: "\(taskId)_start", content: startContent, trigger: startTrigger)
                center.add(startRequest)
            }

            if endReminderDate > now {
                let endContent = UNMutableNotificationContent()
                endContent.title = "⏳ Süre Dolmak Üzere"
                endContent.body = "\(slotEnd) saatine kadar ölçüm yapmayı unutma!"
                endContent.sound = .default

                let endComponents = Calendar.current.dateComponents([.hour, .minute], from: endReminderDate)
                let endTrigger = UNCalendarNotificationTrigger(dateMatching: endComponents, repeats: false)
                let endRequest = UNNotificationRequest(identifier: "\(taskId)_end", content: endContent, trigger: endTrigger)
                center.add(endRequest)
            }
        }

        UserDefaults.standard.set(todayStr, forKey: "lastPlannedDate")
    }

}
