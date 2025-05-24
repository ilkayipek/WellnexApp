//
//  MyProfileVideModel.swift
//  WellnexApp
//
//  Created by MacBook on 4.05.2025.
//

class MyProfileVideModel: BaseViewModel {
    
    func getRelationship(id: String, userType: UserType, closure: @escaping ([PatientDoctorRelationshipModel]?) -> Void) {
        
        let collection = Network.shared.database.collection(FirebaseCollections.patientDoctorRelationship.rawValue)
        var query = collection.whereField("patientId", isEqualTo: id)
        
        if userType == .doctor {
            query = collection.whereField("doctorId", isEqualTo: id)
        }
        
        Network.shared.getMany(of: PatientDoctorRelationshipModel.self, with: query) { [weak self] result in
            guard let self else { closure(nil); return}
            
            switch result {
            case .success(let items):
                closure(items)
            case .failure(let error):
                failAnimation?("HATA: \(error.localizedDescription)")
                closure(nil)
            }
        }
        
    }
    
    func updateRelationship(relationshipModel: PatientDoctorRelationshipModel, closure:@escaping (Bool) -> Void) {
        
        Network.shared.put(relationshipModel, to: .patientDoctorRelationship) { [weak self] result in
            guard let self else {return}
            
            switch result {
                
            case .success(let updatedModel):
                print(updatedModel)
                closure(true)
                successAnimation?("Doktor Hasta ilişkisi \(updatedModel.status) olarak ayarlandı.")
                
            case .failure(let error):
                closure(false)
                failAnimation?("HATA: \(error.localizedDescription) Doktor Hasta İlişkisi Güncellenemedi.")
            }
        }
    }
    
    func signOut(_ closure: @escaping(Bool)->Void) {
        
        do {
            try AuthManager.shared.auth.signOut()
            closure(true)
        } catch let error{
            closure(false)
            failAnimation?("Hata: \(error.localizedDescription)")
        }
        
    }
}
