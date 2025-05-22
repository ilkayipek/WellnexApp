//
//  MyProfileViewController.swift
//  WellnexApp
//
//  Created by MacBook on 4.05.2025.
//

import UIKit

class MyProfileViewController: BaseViewController<MyProfileVideModel> {
    @IBOutlet weak var profileTableView: UITableView!
    var currentUser: UserModel?
    var patientDoctorRelationships = [PatientDoctorRelationshipModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = MyProfileVideModel()
        fethData()
    }
    
    private func setTableView() {
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        profileTableView.registerCellFromNib(MyProfileDetailTableViewCell.self)
        profileTableView.registerCellFromNib(MyProfileDoctorsTableViewCell.self)
        profileTableView.registerCellFromNib(MyProfilePatientsTableViewCell.self)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        profileTableView.refreshControl = refreshControl
    }
    
    @objc func refreshData() {
        fethData()
    }
    
    private func fethData() {
        currentUser = UserInfo.shared.retrieve(key: .userModel)
        
        if currentUser != nil {
            setTableView()
            getRelationships()
        }
    }
    
    private func getRelationships() {
        let id = currentUser!.id
        let userTypeString = currentUser!.userType.rawValue
        let userTypeEnum = UserType(rawValue: userTypeString) ?? .doctor
        
        viewModel?.getRelationship(id: id, userType: userTypeEnum) { [weak self] results in
            guard let self else {return}
            guard let results  else {return}
            
            self.patientDoctorRelationships = results
            self.sortByStatus(status: .pending)
            self.profileTableView.reloadData()
        }
    }
    
    private func sortByStatus(status: RelationshipStatus) {
        
        patientDoctorRelationships.sort {
            $0.status == status.rawValue && $1.status != status.rawValue
        }
    }

}


extension MyProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientDoctorRelationships.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            
            let userDetailCell = createUserDetailCell(at: indexPath)
            return userDetailCell
            
        default:
            let index = indexPath .row - 1
            let relationshipCell = createRelationshipCell(at: indexPath, index: index)
            
            return relationshipCell
        }
        
    }
    
    private func createUserDetailCell(at indexPath: IndexPath) -> UITableViewCell {
        
        let cell = profileTableView.sameNameDequeueReusableCell(MyProfileDetailTableViewCell.self, indexPath: indexPath)
        
        cell.addPatientButtonHandler =  {[weak self] in
            guard let self else { return }
            
            self.transitionToAddPatientScene()
        }
        
        cell.loadCell(currentUser: currentUser!)
        
        return cell
    }
    
    private func createRelationshipCell(at indexPath: IndexPath, index: Int) -> UITableViewCell {
        let userType = currentUser!.userType
        
        switch userType {
            
        case .doctor:
            
            let cell = profileTableView.sameNameDequeueReusableCell(MyProfilePatientsTableViewCell.self, indexPath: indexPath)
            cell.loadCell(relationshipModel: patientDoctorRelationships[index])
            
            return cell
        case .patient:
            let cell = profileTableView.sameNameDequeueReusableCell(MyProfileDoctorsTableViewCell.self, indexPath: indexPath)
            
            
            cell.loadCell(relationshipModel: patientDoctorRelationships[index])
            
            
            cell.acceptButtonHandler = { [weak self] in
                guard let self else { return }
                
                self.updateRelationshipModel(at: index, status: .accepted, isActive: true)
            }
            
            cell.rejectButtonHandler = { [weak self] in
                guard let self else { return }
                
                self.updateRelationshipModel(at: index, status: .rejected, isActive: false)
            }
            
            return cell
        }
    }
    
    private func updateRelationshipModel(at index: Int, status: RelationshipStatus, isActive: Bool ) {
        
        var updateModel = patientDoctorRelationships[index]
        updateModel.status = status.rawValue
        updateModel.isActive = isActive
        
        viewModel?.updateRelationship(relationshipModel: updateModel) { [weak self] status in
            guard let self else {return}
            guard status else {return}
            
            self.patientDoctorRelationships[index] = updateModel
            self.sortByStatus(status: .pending)
            self.profileTableView.reloadData()
        }
    }
    
    private func transitionToAddPatientScene() {
        let targetVc = AddPatientViewController.loadFromNib()
        self.navigationController?.pushViewController(targetVc, animated: true)
    }
    
    
}
