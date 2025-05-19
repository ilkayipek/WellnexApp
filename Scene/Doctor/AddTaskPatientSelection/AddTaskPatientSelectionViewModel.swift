//
//  AddTaskPatientSelectionViewModel.swift
//  WellnexApp
//
//  Created by MacBook on 18.05.2025.
//

class AddTaskPatientSelectionViewModel: BaseViewModel {
    
    func fetchMyRelations(_ closure: @escaping([PatientDoctorRelationshipModel])-> Void) {
        guard let currentUserId = AuthManager.shared.auth.currentUser?.uid else {return}
        
        let network = Network.shared
        let collection = network.database.collection(FirebaseCollections.patientDoctorRelationship.rawValue)
        let query = collection.whereField("isActive", isEqualTo: true).whereField("doctorId", isEqualTo: currentUserId)
        
        gradientLoagingTabAnimation?.startAnimations()
        
        network.getMany(of: PatientDoctorRelationshipModel.self, with: query) { [weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(let relations):
                closure(relations)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                closure([])
            }
            
            gradientLoagingTabAnimation?.stopAnimations()
        }
    }
    
    
    
}
