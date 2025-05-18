//
//  AssignTaskViewModel.swift
//  WellnexApp
//
//  Created by MacBook on 10.05.2025.
//

import Foundation

class AssignTaskEndViewModel: BaseViewModel {
    
    func postTask(_ taskModel: TaskModel, _ closure: @escaping (Bool)->Void) {
        let network = Network.shared
        
        loadingAnimationStart?("")
        network.post(taskModel, to: .task) {[weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(let success):
                closure(true)
            case .failure(let failure):
                failAnimation?("HATA: \(failure.localizedDescription)")
                closure(false)
            }
            
            loadingAnimationStop?()
        }
    }
    
}
