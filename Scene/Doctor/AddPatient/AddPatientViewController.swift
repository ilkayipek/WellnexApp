//
//  AddPatientViewController.swift
//  WellnexApp
//
//  Created by MacBook on 9.05.2025.
//

import UIKit

class AddPatientViewController: BaseViewController<AddPatientViewModel> {
    @IBOutlet weak var patientResultsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var patients = [UserModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = AddPatientViewModel()
        searchBarConfigiguration()
        patientResultsTableViewConfiguration()
    }
    
    private func patientResultsTableViewConfiguration() {
        
        patientResultsTableView.dataSource = self
        patientResultsTableView.delegate = self
        
        patientResultsTableView.registerCellFromNib(AddPattientTableViewCell.self)
    }
    
    private func searchPatients(text: String) {
        viewModel?.searchPatients(input: text) { [weak self] results in
            guard let self else {return}
            
            self.patients = results
            self.patientResultsTableView.reloadData()
        }
    }
    
    private func searchBarConfigiguration() {
        searchBar.delegate = self
    }
    
    
    func addPatientHandler(patient: UserModel) {
        viewModel?.checnkRelationship(patientId: patient.id) { [weak self] status in
            guard let self else {return}
            guard status else {return}
            
            let alert = UIAlertController(title: "Bağlantı Mesajınız:", message: nil, preferredStyle: .alert)
            
            alert.addTextField()
            
            let okAction = UIAlertAction(title: "Tamam", style: .default) { _ in
                if let note = alert.textFields?.first?.text {
                    
                    self.viewModel?.postRelationship(patient: patient, note: note) { status in
                        guard status else {return}
                        
                        //successful
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            
            let cancel = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
            
            alert.addAction(okAction)
            alert.addAction(cancel)
            
            self.present(alert, animated: true)
            
        }
    }

}

extension AddPatientViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return patients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = patientResultsTableView.sameNameDequeueReusableCell(AddPattientTableViewCell.self, indexPath: indexPath)
        
        let patient = patients[indexPath.row]
        cell.loadCell(user: patient)
        
        cell.addPatientHandler = { [weak self] in
            guard let self else {return}
            self.addPatientHandler(patient: patient)
            
        }
        
        return cell
    }
}

extension AddPatientViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        patients.removeAll()
        patientResultsTableView.reloadData()
        
        guard searchText.isEmpty == false else { return }
        
        searchPatients(text: searchText)
    }
    
}

