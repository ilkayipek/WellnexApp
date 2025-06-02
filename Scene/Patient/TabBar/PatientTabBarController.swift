//
//  TabBar.swift
//  WellnexApp
//
//  Created by MacBook on 22.05.2025.
//

import UIKit

class PatientTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        addTabItems()
    }
    
    func addTabItems() {
        
        let homeVc = PatientHomeViewController()
        let assignedTasks = AssignedTasksViewController()
        let reports = ReportsViewController()
        let myProfile = MyProfileViewController()
        
        
        let shadowView = UIView(frame: tabBar.bounds)
        shadowView.backgroundColor = .white
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.shadowOffset = CGSize(width: 0, height: -3)
        shadowView.layer.shadowRadius = 3
        
        tabBar.insertSubview(shadowView, at: 0)
        
        
        homeVc.tabBarItem = UITabBarItem(title: "Günün Görevleri", image: UIImage(systemName: "house"), tag: 0)
        homeVc.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        assignedTasks.tabBarItem = UITabBarItem(title: "Tanımlı Görevler", image: UIImage(systemName: "list.bullet"), tag: 2)
        assignedTasks.tabBarItem.selectedImage = UIImage(systemName: "list.bullet.fill")
        
        myProfile.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person"), tag: 3)
        myProfile.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        reports.tabBarItem = UITabBarItem(title: "Raporlarım", image: UIImage(systemName: "ecg.text.page"), tag: 1)
        reports.tabBarItem.selectedImage = UIImage(systemName: "ecg.text.page.fill")
        
        let controllers = [homeVc,assignedTasks,reports,myProfile]
        
        setViewControllers(controllers, animated: true)
        
        self.selectedIndex = 0
        self.navigationItem.title = controllers[self.selectedIndex].title
        
        
    }
}

extension PatientTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateTitle(for: selectedIndex)
    }
    
    private func updateTitle(for index: Int) {
        switch index {
        case 0:
            self.navigationItem.title = "Günün Görevleri"
        case 1:
            self.navigationItem.title = "Tanımlı Görevler"
        case 2:
            self.navigationItem.title = "Raporlarım"
        case 3:
            self.navigationItem.title = "Profil"
        default:
            self.navigationItem.title = ""
        }
    }
}


