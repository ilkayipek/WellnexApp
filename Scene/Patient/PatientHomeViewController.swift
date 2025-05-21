//
//  PatientHomeViewController.swift
//  WellnexApp
//
//  Created by MacBook on 20.05.2025.
//

import UIKit

class PatientHomeViewController: BaseViewController<PatientHomeViewModel> {
    @IBOutlet weak var taskInstancesTableView: UITableView!
    var allTasks = [TaskInstanceModel]()

    var taskSections: [TaskSection] {
        let upcoming = allTasks.filter { $0.isUpcoming }
        let inProgress = allTasks.filter { $0.isInProgress }
        let overdue = allTasks.filter { $0.isOverdue }

        var sections: [TaskSection] = []

        if !inProgress.isEmpty {
            sections.append(TaskSection(title: "🟡 Devam Eden Görevler", tasks: inProgress))
        }

        if !upcoming.isEmpty {
            sections.append(TaskSection(title: "🔵 Yaklaşan Görevler", tasks: upcoming))
        }

        if !overdue.isEmpty {
            sections.append(TaskSection(title: "🔴 Geçmiş ve Tamamlanmamış", tasks: overdue))
        }

        return sections
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = PatientHomeViewModel()
        configureTableView()
        getTaskInstances()
    }
    
    func configureTableView() {
        taskInstancesTableView.delegate = self
        taskInstancesTableView.dataSource = self
        
        taskInstancesTableView.registerCellFromNib(TaskInstanceTableViewCell.self)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        taskInstancesTableView.refreshControl = refreshControl
    }
    
    func openEditScreen(_ taskInstance: TaskInstanceModel) {
        
    }
    
    private func getTaskInstances() {
        
        viewModel?.fetchTaskInstances { [weak self] results in
            guard let self else {return}
            guard !results.isEmpty else {return}
            
            self.allTasks = results
            self.taskInstancesTableView.reloadData()
            self.taskInstancesTableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc func refreshData() {
        getTaskInstances()
    }

}

extension PatientHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskSections[section].tasks.count
    }

    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = taskSections[section].title
        label.font = UIFont(name: "Georgia-Bold", size: 25)
        label.textColor = UIColor.activePrimaryButtonColor
        label.backgroundColor = UIColor.clear
        label.textAlignment = .left
        label.numberOfLines = 1
        label.frame = CGRect(x: 0, y: 0, width: tableView.frame.width - 32, height: 40)

        let container = UIView()
        container.addSubview(label)
        return container
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskInstancesTableView.sameNameDequeueReusableCell(TaskInstanceTableViewCell.self, indexPath: indexPath)
        
        let task = taskSections[indexPath.section].tasks[indexPath.row]
        cell.loadCell(task)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = taskSections[indexPath.section].tasks[indexPath.row]

            if task.isInProgress {
               
                openEditScreen(task)
            }
    }
    
    
}
