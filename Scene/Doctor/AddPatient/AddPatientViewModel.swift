//
//  AddPatientViewModel.swift
//  WellnexApp
//
//  Created by MacBook on 9.05.2025.
//

import Foundation

class AddPatientViewModel: BaseViewModel {
    
    func searchPatients(input: String, closure: @escaping ([UserModel]) -> Void) {
        
        let collectionString = FirebaseCollections.users.rawValue
        let collection = Network.shared.database.collection(collectionString)
        let endText = "\(input)\u{f8ff}"
        
        let query = collection.order(by: "username")
            .start(at: [input])
            .end(at: [endText])
        
        gradientLoagingTabAnimation?.startAnimations()
        
        Network.shared.getMany(of: UserModel.self, with: query) { [weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(let users):
                closure(users)
                
            case .failure(let error):
                self.failAnimation?("HATA: \(error.localizedDescription)")
                closure([UserModel]())
            }
            self.gradientLoagingTabAnimation?.stopAnimations()
        }
        
    }
    
    func postRelationship(patient: UserModel,note: String, closure:@escaping (Bool)->Void) {
        
        guard let relationModel = createRelationshipModel(patient: patient, note: note) else {
            closure(false); return
        }
        
        let network = Network.shared
        gradientLoagingTabAnimation?.startAnimations()
        
        network.post(relationModel, to: .patientDoctorRelationship) { [weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(_):
                closure(true)
                self.successAnimation?("Bağlantı Talebi Başarılı")
                
            case .failure(let error):
                closure(false)
                self.failAnimation?("HATA: \(error.localizedDescription)")
                
            }
            
            self.gradientLoagingTabAnimation?.stopAnimations()
            
        }
    }
    
    
    func checnkRelationship(patientId: String, closure: @escaping(Bool)->Void) {
        
        let collectionString = FirebaseCollections.patientDoctorRelationship.rawValue
        let collection = Network.shared.database.collection(collectionString)
        
        let doctorId = AuthManager.shared.auth.currentUser!.uid
        
        let query = collection.whereField("doctorId", isEqualTo: doctorId)
            .whereField("patientId", isEqualTo: patientId)
        
        Network.shared.getOne(of: PatientDoctorRelationshipModel.self, with: query){ [weak self] result in
            guard let self else {return}
            
            switch result {
                
            case .success(_):
                self.alertMessage?("Daha önce bağlantı oluşturulmuştur.","","Tamam",nil)
                closure(false)
            
            case .failure(_):
                closure(true)
                
            }
        }
    }
    
    private func createRelationshipModel(patient: UserModel,note: String) -> PatientDoctorRelationshipModel? {
        
        guard let doctor: UserModel = UserInfo.shared.retrieve(key: .userModel) else {
             return nil
        }
                
        let generatedId = UUID().uuidString
        let doctorId = doctor.id
        let doctorName = doctor.fullName
        let patientId = patient.id
        let patientName = patient.fullName
    
        let relationship = PatientDoctorRelationshipModel(id: generatedId, doctorId: doctorId, patientId: patientId, patientName: patientName, doctorName: doctorName, status: .pending, note: note)
        
        return relationship
    }
    
}
