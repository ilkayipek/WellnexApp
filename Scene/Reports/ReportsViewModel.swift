//
//  ReportsViewModel.swift
//  WellnexApp
//
//  Created by MacBook on 28.05.2025.
//

class ReportsViewModel: BaseViewModel {
    
    
    func fetchReports(_ closure: @escaping ([ReportModel]) -> Void) {
        guard let currentUsr: UserModel = UserInfo.shared.retrieve(key: .userModel) else {return}
        
        switch currentUsr.userType {
        case .doctor:
            fetchReportsForDoctor(currentUsr.id, closure)
        case .patient:
            fetchReportsForPatient(currentUsr.id, closure)
        }
    }
    
    private func fetchReportsForPatient(_ id: String, _ closure: @escaping ([ReportModel]) -> Void) {
        
    }
    
    private func fetchReportsForDoctor(_ id: String, _ closure: @escaping ([ReportModel]) -> Void) {
        
    }
    
    func postReportModel(_ report: ReportModel, _ closure: @escaping (Bool) -> Void) {
        
    }

}
