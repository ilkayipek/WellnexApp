//
//  AddTaskPatientSelectionViewController.swift
//  WellnexApp
//
//  Created by MacBook on 18.05.2025.
//

import UIKit

class AddTaskPatientSelectionViewController: BaseViewController<AddTaskPatientSelectionViewModel> {
    @IBOutlet weak var myPatientsTableView: UITableView!
    
    private var myPatientsRelations = [PatientDoctorRelationshipModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AddTaskPatientSelectionViewModel()
        
        myPatientsTableViewConfigure()
        getMyPatientsRelations()
    }
    
    private func myPatientsTableViewConfigure() {
        myPatientsTableView.delegate = self
        myPatientsTableView.dataSource = self
        
        myPatientsTableView.registerCellFromNib(MyProfilePatientsTableViewCell.self)
    }
    
    private func getMyPatientsRelations() {
        
        viewModel?.fetchMyRelations { [weak self] result in
            guard let self else {return}
            
            self.myPatientsRelations = result
            self.myPatientsTableView.reloadData()
        }
    }
    
    private func switchToAssignTaskScene(with relationModel: PatientDoctorRelationshipModel) {
        
        let targetVc = AssignTaskStartViewController.loadFromNib()
        targetVc.setRelationModel(relationModel)
        
        self.navigationController?.pushViewController(targetVc, animated: true)
    }

}

extension AddTaskPatientSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPatientsRelations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myPatientsTableView.sameNameDequeueReusableCell(MyProfilePatientsTableViewCell.self, indexPath: indexPath)
        
        let relation = myPatientsRelations[indexPath.row]
        cell.loadCell(relationshipModel: relation)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let relation = myPatientsRelations[indexPath.row]
        switchToAssignTaskScene(with: relation)
    }
    
    
}
