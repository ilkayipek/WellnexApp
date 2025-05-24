//
//  TaskAndDetailsViewModel.swift
//  WellnexApp
//
//  Created by MacBook on 22.05.2025.
//

import Foundation

class AssignedTasksViewModel: BaseViewModel {
    
    func fetchTasks(patientId: String,_ closure: @escaping([TaskModel])->Void ) {
        
        let measureTypes: [MeasurementModel]? = UserInfo.shared.retrieve(key: .measureTypes)
        guard let measureTypes, !measureTypes.isEmpty else {
            closure([]);return
        }
        
        let date = Date()
        
        let network = Network.shared
        let collection = network.database.collection(FirebaseCollections.task.rawValue)
        let query = collection.whereField("patientId", isEqualTo: patientId)
            .whereField("endDate", isGreaterThanOrEqualTo: date)
            .order(by: "endDate", descending: true)
        
        gradientLoagingTabAnimation?.startAnimations()
        
        network.getMany(of: TaskModel.self, with: query) { [weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(var tasks):
                
                tasks = tasks.map { task in
                    var updatedTask = task
                    if let matchedMeasure = measureTypes.first(where: { $0.id == task.measureTypeId }) {
                        updatedTask.measureTypeModel = matchedMeasure
                    }
                    return updatedTask
                }
                
                closure(tasks)
            case .failure(let error):
                closure([])
                print("Error: \(error)")
            }
            
            self.gradientLoagingTabAnimation?.stopAnimations()
        }
    }
}
