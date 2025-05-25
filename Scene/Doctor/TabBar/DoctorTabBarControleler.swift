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
        
        addTabItems()
    }
    
    func addTabItems() {
        
        let myPatients = MyPatientsViewController()
        let patientSelect = AddTaskPatientSelectionViewController()
        let myProfile = MyProfileViewController()
        
        
        let shadowView = UIView(frame: tabBar.bounds)
        shadowView.backgroundColor = .white
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.shadowOffset = CGSize(width: 0, height: -3)
        shadowView.layer.shadowRadius = 3
        
        tabBar.insertSubview(shadowView, at: 0)
        
        
        myPatients.tabBarItem = UITabBarItem(title: "Hastalarım", image: UIImage(systemName: "person.3"), tag: 0)
        myPatients.tabBarItem.selectedImage = UIImage(systemName: "person.3.fill")
        
        patientSelect.tabBarItem = UITabBarItem(title: "Görev Tanımla", image: UIImage(systemName: "plus.app"), tag: 2)
        patientSelect.tabBarItem.selectedImage = UIImage(systemName: "plus.app.fill")
        
        myProfile.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person"), tag: 3)
        myProfile.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        setViewControllers([myPatients,patientSelect,myProfile], animated: true)
        
    }
}

