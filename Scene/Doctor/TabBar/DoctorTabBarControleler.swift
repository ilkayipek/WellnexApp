//
//  DoctorTabBarControleler.swift
//  WellnexApp
//
//  Created by MacBook on 24.05.2025.
//

import UIKit

class DoctorTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        addTabItems()
    }
    
    func addTabItems() {
        
        let myPatients = MyPatientsViewController()
        myPatients.title = "Hastalarım"
        
        let myReports = ReportsViewController()
        myReports.title = "Raporlarım"
        
        let patientSelect = AddTaskPatientSelectionViewController()
        patientSelect.title = "Görev Tanımla"
        
        let myProfile = MyProfileViewController()
        myProfile.title = "Profil"
        
        
        let shadowView = UIView(frame: tabBar.bounds)
        shadowView.backgroundColor = .white
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.shadowOffset = CGSize(width: 0, height: -3)
        shadowView.layer.shadowRadius = 3
        
        tabBar.insertSubview(shadowView, at: 0)
        
        myPatients.tabBarItem = UITabBarItem(title: "Hastalarım", image: UIImage(systemName: "person.3"), tag: 0)
        myPatients.tabBarItem.selectedImage = UIImage(systemName: "person.3.fill")
        
        myReports.tabBarItem = UITabBarItem(title: "Raporlarım", image: UIImage(systemName: "ecg.text.page"), tag: 1)
        myReports.tabBarItem.selectedImage = UIImage(systemName: "ecg.text.page.fill")
        
        patientSelect.tabBarItem = UITabBarItem(title: "Görev Tanımla", image: UIImage(systemName: "plus.app"), tag: 2)
        patientSelect.tabBarItem.selectedImage = UIImage(systemName: "plus.app.fill")
        
        myProfile.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person"), tag: 3)
        myProfile.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        let controllers = [myPatients,myReports,patientSelect,myProfile]
        
        
        setViewControllers(controllers, animated: true)
        self.selectedIndex = 0
        self.navigationItem.title = controllers[self.selectedIndex].title
    }
}

extension DoctorTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateTitle(for: selectedIndex)
    }
    
    private func updateTitle(for index: Int) {
        switch index {
        case 0:
            self.navigationItem.title = "Hastalarım"
        case 1:
            self.navigationItem.title = "Raporlarım"
        case 2:
            self.navigationItem.title = "Görev Tanımla"
        case 3:
            self.navigationItem.title = "Profil"
        default:
            self.navigationItem.title = ""
        }
    }
}

