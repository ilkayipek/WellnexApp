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
        
        let todayStr = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        let center = UNUserNotificationCenter.current()
        
        for result in results {
            
            let taskId = result.id
            let slotStart = result.slotStart
            let components = slotStart.split(separator: ":")
            guard components.count == 2,
                  let hour = Int(components[0]),
                  let minute = Int(components[1]) else {
                continue
            }
            
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            let content = UNMutableNotificationContent()
            content.title = "📍 Görev Zamanı"
            content.body = "\(slotStart) saatinde ölçüm yapmayı unutma!"
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: taskId, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("❌ Bildirim planlanamadı: \(error.localizedDescription)")
                } else {
                    print("✅ Bildirim planlandı: \(taskId) için \(slotStart)")
                }
            }
        }
        
        // ✅ Başarıyla planladıysak UserDefaults’a işaret bırak
        UserDefaults.standard.set(todayStr, forKey: "lastPlannedDate")
    }
}
