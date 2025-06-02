//
//  ReportsViewModel.swift
//  WellnexApp
//
//  Created by MacBook on 28.05.2025.
//

class ReportsViewModel: BaseViewModel {
    
    let network = Network.shared
    
    func fetchReports(_ closure: @escaping ([ReportModel]) -> Void) {
        guard let currentUsr: UserModel = UserInfo.shared.retrieve(key: .userModel) else {return}
        
        switch currentUsr.userType {
        case .doctor:
            fetchReportsForUserType("doctorId",currentUsr.id, closure)
        case .patient:
            fetchReportsForUserType("patientId",currentUsr.id, closure)
        }
    }
    
    private func fetchReportsForUserType(_ field: String,_ id: String, _ closure: @escaping ([ReportModel]) -> Void) {
        let network = Network.shared
        
        let collectionStr = FirebaseCollections.report.rawValue
        let collection = network.database.collection(collectionStr)
        
        let collectionsQuery = collection.whereField(field, isEqualTo: id)
            .order(by: "createdAt", descending: true)
        
        network.getMany(of: ReportModel.self, with: collectionsQuery) { [weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(let reports):
                closure(reports)
            case .failure(_):
                closure([])
            }
        }
    }
    
    func postReportModel(_ report: ReportModel, _ closure: @escaping (Bool) -> Void) {
        
        Network.shared.post(report, to: .report) { [weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(_):
                self.postListener(report.id, closure)
            case .failure(let failure):
                failAnimation?("HATA: \(failure.localizedDescription)")
                closure(false)
            }
        }
    }
    
    private func postListener(_ reportId: String, _ closure: @escaping (Bool) -> Void) {
        
        let db = Network.shared.database
        let collectionStr = FirebaseCollections.report.rawValue
        let collection = db.collection(collectionStr)
        
        collection.whereField("id", isEqualTo: reportId)
            .whereField("isComplete", isEqualTo: true).addSnapshotListener { [weak self] listener, error in
                guard let self else {return}
                guard error == nil else {
                    
                    self.failAnimation?("Dinleme Sırasında Bir Hata Oluştu: \(error?.localizedDescription ?? "")")
                    closure(false)
                    return
                }
                
                guard let documents = listener?.documents, !documents.isEmpty else {
                    closure(false)
                    return
                }
                
                closure(true)
            }
    }

}
