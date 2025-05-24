//
//  TasksAndDetailsViewController.swift
//  WellnexApp
//
//  Created by MacBook on 22.05.2025.
//

import UIKit

class AssignedTasksViewController: BaseViewController<AssignedTasksViewModel> {
    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet weak var emptyMessageContainerView: CustomContainerUIView!
    
    private var tasks = [TaskModel]()

    private var patientId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       viewModel = AssignedTasksViewModel()
        
        loadPatientId()
        tableViewConfigure()
        getTasks()
        
    }
    
    func setPatientId(_ id: String) {
        patientId = id
    }
    
    private func getTasks() {
        guard let patientId else {return}
        
        viewModel?.fetchTasks(patientId: patientId) { [weak self] tasks in
            guard let self else { return}
            
            self.tasks = tasks
            self.emptyMessageContainerView.isHidden = !tasks.isEmpty
            self.tasksTableView.reloadData()
            self.tasksTableView.refreshControl?.endRefreshing()
            
        }
    }
    
    private func loadPatientId() {
        
        guard let currentUsr: UserModel = UserInfo.shared.retrieve(key: .userModel) else {return}
        guard currentUsr.userType == .patient else {return}
        
        patientId = currentUsr.id
    }
    
    private func tableViewConfigure() {
        
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        
        tasksTableView.registerCellFromNib(AssignedTasksTableViewCell.self)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tasksTableView.refreshControl = refreshControl
    }
    
    @objc private func reloadData() {
        getTasks()
    }
    
}

extension AssignedTasksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tasksTableView.sameNameDequeueReusableCell(AssignedTasksTableViewCell.self, indexPath: indexPath)
        
        let task = tasks[indexPath.row]
        cell.loadCell(task)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        let targetVc = AssignedTaskDetailViewController.loadFromNib()
        targetVc.loadTaskData(task)
        self.navigationController?.pushViewController(targetVc, animated: true)
        
    }
    
}
