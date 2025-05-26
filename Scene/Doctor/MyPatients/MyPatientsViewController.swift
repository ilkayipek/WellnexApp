//
//  MyPatientsViewController.swift
//  WellnexApp
//
//  Created by MacBook on 26.05.2025.
//

import UIKit

class MyPatientsViewController: BaseViewController<MyPatientsViewModel> {
    @IBOutlet weak var myPatientRelationsTableView: UITableView!
    
    var myPatientRelations = [PatientDoctorRelationshipModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = MyPatientsViewModel()
        tableViewConfigure()
        getMyPatientRelations()
    }

    private func tableViewConfigure() {
        myPatientRelationsTableView.delegate = self
        myPatientRelationsTableView.dataSource = self
        
        myPatientRelationsTableView.registerCellFromNib(MyPatientsTableViewCell.self)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.getMyPatientRelations), for: .valueChanged)
        myPatientRelationsTableView.refreshControl = refreshControl
    }
    
    @objc private func getMyPatientRelations() {
        viewModel?.fetchMyPatients { [weak self] results in
            guard let self else {return}
            
            myPatientRelationsTableView.refreshControl?.endRefreshing()
            self.myPatientRelations = results
            self.myPatientRelationsTableView.reloadData()
            
        }
    }
    
    private func deleteRelationship(at indexPath: IndexPath) {
        let relation = myPatientRelations[indexPath.row]
        
        viewModel?.deletePatient(relation) { [weak self] status in
            guard let self else {return}
            guard status else {return}
            
            self.myPatientRelations.remove(at: indexPath.row)
            self.myPatientRelationsTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    

}

extension MyPatientsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPatientRelations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myPatientRelationsTableView.sameNameDequeueReusableCell(MyPatientsTableViewCell.self, indexPath: indexPath)
        
        let relation = myPatientRelations[indexPath.row]
        cell.loadCell(relation)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            deleteRelationship(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let patientId = myPatientRelations[indexPath.row].patientId
        
        let targetVc = MyPatientDetailViewController.loadFromNib()
        targetVc.loadData(patientId: patientId)
        self.navigationController?.pushViewController(targetVc, animated: true)
    }
}
