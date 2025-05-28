//
//  MyPatientDetailViewController.swift
//  WellnexApp
//
//  Created by MacBook on 26.05.2025.
//

import UIKit

class MyPatientDetailViewController: BaseViewController<MyPatientDetailViewModel> {
    @IBOutlet weak var myPatientDetailTableView: UITableView!
    
    private var patientId: String?
    private var patientDetail: UserModel?
    private var segmentedControlSelectedIndex: Int = 0
    private var weeklyTaskInstanceSections = [TaskSection]()
    private var assignedTasks = [TaskModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = MyPatientDetailViewModel()
        tableViewConfigure()
        getDetails()
    }
    
    func loadData(patientId: String) {
        self.patientId = patientId
    }
    
    private func tableViewConfigure() {
        myPatientDetailTableView.delegate = self
        myPatientDetailTableView.dataSource = self
        
        myPatientDetailTableView.registerCellFromNib(MyPatientInfoTableViewCell.self)
        myPatientDetailTableView.registerCellFromNib(MyPatientTaskInstanceTableViewCell.self)
        myPatientDetailTableView.registerCellFromNib(AssignedTasksTableViewCell.self)
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getDetails), for: .valueChanged)
        myPatientDetailTableView.refreshControl = refreshControl
    }
    

    
    
    @objc private func getDetails() {
        guard let patientId else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        viewModel?.fetchDetails(patientId) { [weak self] patient, taskSections in
            guard let self else {return}
            guard let patient else {return}
            
            self.patientDetail = patient
            self.weeklyTaskInstanceSections = taskSections
            self.myPatientDetailTableView.reloadData()
            self.myPatientDetailTableView.refreshControl?.endRefreshing()
        }
        
        viewModel?.fetchAssignedTasks(patientId) { [weak self] results in
            guard let self else {return}
            
            self.assignedTasks = results
            self.myPatientDetailTableView.reloadData()
        }
    }

    private func deleteTask(_ indexPath: IndexPath) {
        let task = assignedTasks[indexPath.row]
        
        viewModel?.deleteTask(task) { [weak self] status in
            guard let self else {return}
            guard status else {return}
            
            self.assignedTasks.remove(at: indexPath.row)
            self.myPatientDetailTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    private func reportCreateTask(taskId: String, patientId: String) {
        guard let currentUsrId = AuthManager.shared.auth.currentUser?.uid else {return}
        
        let targetVc = DoctorTabBarController.loadFromNib()
        targetVc.selectedIndex = 1
        
        if let selectedVc = targetVc.selectedViewController as? ReportsViewController {
            selectedVc.postReport(taskId: taskId, patientId: patientId, doctorId: currentUsrId)
        }
        
        let navigationController = UINavigationController(rootViewController: targetVc)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }

}

extension MyPatientDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentedControlSelectedIndex == 0 {
            return weeklyTaskInstanceSections.count
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != 0 {
            if segmentedControlSelectedIndex == 0 {
                return weeklyTaskInstanceSections[section].tasks.count
            } else {
                return assignedTasks.count
            }
            
        } else {
            return patientDetail == nil ? 0 : 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segmentedControlSelectedIndex == 0 {
            return weeklyTaskInstanceSections[section].title
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = myPatientDetailTableView.sameNameDequeueReusableCell(MyPatientInfoTableViewCell.self, indexPath: indexPath)
            
            cell.loadCell(currentUser: patientDetail!)
            cell.segmentedControlDelegate = self
            
            return cell
        } else if segmentedControlSelectedIndex == 0{
            let cell = myPatientDetailTableView.sameNameDequeueReusableCell(MyPatientTaskInstanceTableViewCell.self, indexPath: indexPath)
            
            let taskInstance = weeklyTaskInstanceSections[indexPath.section].tasks[indexPath.row]
            cell.loadCell(taskInstance)
            return cell
            
        } else {
            let cell = myPatientDetailTableView.sameNameDequeueReusableCell(AssignedTasksTableViewCell.self, indexPath: indexPath)
            
            let task = assignedTasks[indexPath.row]
            cell.loadCell(task)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section != 0, segmentedControlSelectedIndex == 1{
            
            let targetVc = AssignedTaskDetailViewController.loadFromNib()
            targetVc.loadTaskData(assignedTasks[indexPath.row])
            self.navigationController?.pushViewController(targetVc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if indexPath.section != 0, segmentedControlSelectedIndex == 1 {
            
            if editingStyle == .delete {
                
                deleteTask(indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool {
        
        return indexPath.section != 0 && segmentedControlSelectedIndex == 1
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section != 0, segmentedControlSelectedIndex == 1 {
            let reportAction = UIContextualAction(style: .normal, title: "Rapor Oluştur") { [weak self] (action, view, completionHandler) in
                guard let self else {return}
                
                let taskId = assignedTasks[indexPath.row].id
                let patientId = self.patientId ?? ""
                
                self.reportCreateTask(taskId: taskId, patientId: patientId)
                print("Rapor oluşturuluyor: \(taskId) id ye sahip task")
                
                completionHandler(true)
            }
            
            reportAction.backgroundColor = .systemBlue
            reportAction.image = UIImage(systemName: "doc.text")
            
            let configuration = UISwipeActionsConfiguration(actions: [reportAction])
            configuration.performsFirstActionWithFullSwipe = false

            return configuration
        }
        return nil
       
    }


}

extension MyPatientDetailViewController: SegmentedControlDelegate {
    
    func valueChanged(to index: Int) {
        
        segmentedControlSelectedIndex = index
        myPatientDetailTableView.reloadData()
    }
}
