//
//  AssignTaskEndViewModel.swift
//  WellnexApp
//
//  Created by MacBook on 16.05.2025.
//

class AssignTaskStartViewModel: BaseViewModel {
    
    func fetchMeasurements(_ closure: @escaping([MeasurementModel])->Void) {
        let network = Network.shared
        let collection = network.database.collection(FirebaseCollections.measureTypes.rawValue)
        let query = collection.order(by: "order")
        
        gradientLoagingTabAnimation?.startAnimations()
        network.getMany(of: MeasurementModel.self, with: query) { [weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(let results):
                closure(results)
            case .failure(let error):
                self.failAnimation?("HATA: \(error.localizedDescription)")
                closure([])
            }
            
            self.gradientLoagingTabAnimation?.stopAnimations()
        }
    }
    
    
}
