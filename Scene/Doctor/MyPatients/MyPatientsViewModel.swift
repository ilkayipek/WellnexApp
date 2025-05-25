//
//  MyPatientsViewModel.swift
//  WellnexApp
//
//  Created by MacBook on 26.05.2025.
//

class MyPatientsViewModel: BaseViewModel {
    
    func fetchMyPatients(_ closure: @escaping([PatientDoctorRelationshipModel])->Void) {
        guard let currentUsrId = AuthManager.shared.auth.currentUser?.uid else {
            closure([]); return
        }
        
        let network = Network.shared
        let collectionStr = FirebaseCollections.patientDoctorRelationship.rawValue
        let collection = network.database.collection(collectionStr)
        let query = collection.whereField("doctorId", isEqualTo: currentUsrId)
            .whereField("isActive", isEqualTo: true)
        
        gradientLoagingTabAnimation?.startAnimations()
        
        network.getMany(of: PatientDoctorRelationshipModel.self, with: query) {[weak self] result in
            guard let self else {return}
            
            switch result {
                
            case .success(let patients):
                closure(patients)
            case .failure(let error):
                failAnimation?("HATA: \(error.localizedDescription)")
                closure([])
            }
            
            self.gradientLoagingTabAnimation?.stopAnimations()
        }
        
    }
    
    func deletePatient(_ relation: PatientDoctorRelationshipModel, _ closure: @escaping(Bool)->Void) {
        
        alertMessage?("Silmek İstediğinize Emin Misiniz?","UYARI !", "Sil") {[weak self] _ in
            guard let self else {return}
            
            let network = Network.shared
            
            loadingAnimationStart?("")
            network.delete(relation, in: .patientDoctorRelationship) { result in
                
                
                switch result {
                case .success(_):
                    
                    closure(true)
                    self.loadingAnimationStop?()
                case .failure(let failure):
                    
                    closure(false)
                    self.failAnimation?("HATA: \(failure.localizedDescription)")
                }
            }
        }
        
    }
}
