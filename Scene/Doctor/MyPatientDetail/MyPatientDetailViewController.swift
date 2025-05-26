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
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getDetails), for: .valueChanged)
        myPatientDetailTableView.refreshControl = refreshControl
    }
    
    func valueChangedSegmentedControl(_ index: Int) {
        segmentedControlSelectedIndex = index
        myPatientDetailTableView.reloadData()
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
    }

    

}

extension MyPatientDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        weeklyTaskInstanceSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != 0 {
            return weeklyTaskInstanceSections[section].tasks.count
        } else {
            return patientDetail == nil ? 0 : 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return weeklyTaskInstanceSections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = myPatientDetailTableView.sameNameDequeueReusableCell(MyPatientInfoTableViewCell.self, indexPath: indexPath)
            
            cell.segmentedControlHandler? = { [weak self] index in
                guard let self else {return}
                
                self.valueChangedSegmentedControl(index)
            }
            
            cell.loadCell(currentUser: patientDetail!)
            return cell
        } else {
            let cell = myPatientDetailTableView.sameNameDequeueReusableCell(MyPatientTaskInstanceTableViewCell.self, indexPath: indexPath)
            
            let taskInstance = weeklyTaskInstanceSections[indexPath.section].tasks[indexPath.row]
            cell.loadCell(taskInstance)
            return cell
            
        }
        
    }
}
