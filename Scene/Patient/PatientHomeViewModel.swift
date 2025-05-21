//
//  PatientHomeViewModel.swift
//  WellnexApp
//
//  Created by MacBook on 20.05.2025.
//

import Foundation

class PatientHomeViewModel: BaseViewModel {
    
    
    func fetchTaskInstances(_ closure: @escaping([TaskInstanceModel])->Void ) {
        //guard let curentUsr: UserModel = UserInfo.shared.retrieve(key: .userModel) else {return}
        let usrId = "70tcDt3dzYYnMyb33h6f0BnIyQ53"
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        
        
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            closure([])
            return
        }
        
        let network = Network.shared
        let collection = network.database.collection(FirebaseCollections.taskInstances.rawValue)
        let query = collection.whereField("patientId", isEqualTo: usrId)
            .whereField("date", isGreaterThanOrEqualTo: startOfDay)
            .whereField("date", isLessThan: endOfDay)
        
        gradientLoagingTabAnimation?.startAnimations()
        
        network.getMany(of: TaskInstanceModel.self, with: query) { [weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(let results):
                
                self.fetchMeasureModels { measureTypes in
                    guard !measureTypes.isEmpty else {
                        self.gradientLoagingTabAnimation?.stopAnimations()
                        closure([]); return
                    }
                    
                    let newResults = results.map { taskInst in
                        var task = taskInst
                        task.measureTypeModel = measureTypes.first(where: { $0.id == taskInst.measureTypeId })
                        return task
                    }
                    
                    self.gradientLoagingTabAnimation?.stopAnimations()
                    closure(newResults)
                }
                
            case .failure(let error):
                
                self.failAnimation?("HATA: \(error.localizedDescription)")
                self.gradientLoagingTabAnimation?.stopAnimations()
                closure([])
            }
            
        }
    }
    
    private func fetchMeasureModels(_ closure: @escaping([MeasurementModel])->Void ) {
        let network = Network.shared
        let collectionName = FirebaseCollections.measureTypes.rawValue
        let collection = network.database.collection(collectionName)
        let query = collection.order(by: "id")
        
        
        
        network.getMany(of: MeasurementModel.self, with: query) { [weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(let results):
                closure(results)
            case .failure(let error):
                closure([])
                self.failAnimation?("HATA: \n\(error.localizedDescription)")
            }
        }
    }
}
