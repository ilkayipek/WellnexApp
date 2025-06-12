//
//  ReportsViewController.swift
//  WellnexApp
//
//  Created by MacBook on 28.05.2025.
//

import UIKit

class ReportsViewController: BaseViewController<ReportsViewModel> {
    
    @IBOutlet weak var reportsTableView: UITableView!
    @IBOutlet weak var emptyMessageView: CustomContainerUIView!
    
    private var reports = [ReportModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ReportsViewModel()
        configureTableView()
        getReports()
    }
    
    private func configureTableView() {
        reportsTableView.delegate = self
        reportsTableView.dataSource = self
        
        reportsTableView.registerCellFromNib(ReportsTableViewCell.self)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getReports), for: .valueChanged)
        reportsTableView.refreshControl = refreshControl
    }
    
    func postReport(task: TaskModel, patientId: String, doctorId: String) {
        
        let reportModel = ReportModel(id: UUID().uuidString, taskId: task.id, patientId: patientId, doctorId: doctorId, isComplete: false, taskModel: task)
        
        reports.insert(reportModel, at: 0)
        reportsTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
        viewModel?.postReportModel(reportModel) { [weak self] status in
            guard let self else { return }
            guard status else {return}
            
            self.getReports()
        }
        
    }
    
    private func deleteReport(indexPath: IndexPath,_ report: ReportModel) {
        
        viewModel?.deleteReportModel(report) { [weak self] status in
            guard let self else {return}
            
            self.reports.remove(at: indexPath.row)
            self.reportsTableView.reloadData()
        }
    }
    
    @objc private func getReports() {
        
        viewModel?.fetchReports { [weak self] reports in
            guard let self else {return}
            
            self.reports = reports
            self.emptyMessageView.isHidden = !reports.isEmpty
            self.reportsTableView.reloadData()
            self.reportsTableView.refreshControl?.endRefreshing()
        }
        
    }

}

extension ReportsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reportsTableView.sameNameDequeueReusableCell(ReportsTableViewCell.self, indexPath: indexPath)
        
        let report = reports[indexPath.row]
        cell.loadCell(report)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        let report = reports[indexPath.row]
        
        
        if report.isComplete {
            
            if editingStyle == .delete {
                
                deleteReport(indexPath: indexPath, report)
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool {
        guard let user: UserModel = UserInfo.shared.retrieve(key: .userModel) else {return false}
        
        let report = reports[indexPath.row]
        
        return report.isComplete && user.userType == .doctor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let report = reports[indexPath.row]
        guard report.isComplete else {return}
        
        let targetVc = ReportDetailViewController.loadFromNib()
        targetVc.setReportModel(report)
        
        self.navigationController?.pushViewController(targetVc, animated: true)
    }
}
