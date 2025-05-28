//
//  ReportsViewController.swift
//  WellnexApp
//
//  Created by MacBook on 28.05.2025.
//

import UIKit

class ReportsViewController: BaseViewController<ReportsViewModel> {
    @IBOutlet weak var reportsTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ReportsViewModel()
    }
    
    func postReport(taskId: String, patientId: String, doctorId: String) {
        
        let reportModel = ReportModel(id: UUID().uuidString, taskId: taskId, patientId: patientId, doctorId: doctorId, isComplete: false)
        
        viewModel?.postReportModel(reportModel) { [weak self] status in
            guard let self else { return }
            guard status else {return}
            
            
            
        }
        
    }
    
    private func loadReports() {
        
    }

}
