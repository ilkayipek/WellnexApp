//
//  MyPatientDetailViewModel.swift
//  WellnexApp
//
//  Created by MacBook on 26.05.2025.
//

import Foundation

class MyPatientDetailViewModel: BaseViewModel {
    
    private func fetchPatient(_ patientId: String,_ closure: @escaping(UserModel?)->Void) {
        
        let network = Network.shared
        let collectionStr = FirebaseCollections.users.rawValue
        let collection = network.database.collection(collectionStr)
        let query = collection.whereField("id", isEqualTo: patientId)
        
        network.getOne(of: UserModel.self, with: query) { [weak self] result in
            guard let self else {closure(nil); return}
            
            switch result {
            case .success(let usr):
                closure(usr)
            case .failure(let failure):
                failAnimation?("HATA: \(failure.localizedDescription)")
            }
        }
    }
    
    func fetchDetails(_ patientId: String,_ closure: @escaping(UserModel?,[TaskSection])->Void) {
        
        gradientLoagingTabAnimation?.startAnimations()
        
        fetchPatient(patientId) { [weak self] usrModel in
            guard let self else {closure(nil, []); return}
            guard let usrModel else {closure(nil, []); return}
            
            let now = Date()
            let calendar = Calendar.current
            let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
            
            let network = Network.shared
            let collectionStr = FirebaseCollections.taskInstances.rawValue
            let collection = network.database.collection(collectionStr)
            let query = collection.whereField("patientId", isEqualTo: patientId)
                .whereField("date", isLessThanOrEqualTo: now)
                .whereField("date", isGreaterThanOrEqualTo: oneWeekAgo)
            
            network.getMany(of: TaskInstanceModel.self, with: query) { result in
                
                switch result {
                    
                case .success(let results):
                    
                    let sections = self.groupTasksByDate(results)
                    closure(usrModel, sections)
                    
                case .failure(let error):
                    
                    closure(nil, [])
                    self.failAnimation?("HATA: \(error.localizedDescription)")
                }
                
                self.gradientLoagingTabAnimation?.stopAnimations()
            }
        }
    }
    
    func groupTasksByDate(_ tasks: [TaskInstanceModel]) -> [TaskSection] {
        guard let measureTypes: [MeasurementModel] = UserInfo.shared.retrieve(key: .measureTypes) else {return []}
        
        let newTasks: [TaskInstanceModel] = tasks.compactMap { task in
            var newTask = task
            newTask.measureTypeModel = measureTypes.first(where: { $0.id == newTask.measureTypeId })
            return newTask
        }
        
        var groupedDict: [String: [TaskInstanceModel]] = [:]
        
        for task in newTasks {
            let dateKey = task.date?.getDayMonthYear() ?? ""
            groupedDict[dateKey, default: []].append(task)
        }
        
        var sections = groupedDict
            .sorted { $0.key > $1.key }
            .map { key, value in
                let sorted = value.sorted { $0.slotStartAsDate ?? Date() > $1.slotStartAsDate ?? Date() }
                return TaskSection(title: key, tasks: sorted)
            }
        
        let firstSec = TaskSection(title: "Kullanıcı Detay", tasks: [])
        sections.insert(firstSec, at: 0)
        
        return sections
    }
    
    
}
