//
//  MyPatientInfoTableViewCell.swift
//  WellnexApp
//
//  Created by MacBook on 26.05.2025.
//

import UIKit

class MyPatientInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userType: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var taskInstanceSegmentedControl: UISegmentedControl!
    
    var segmentedControlHandler: ((Int) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func loadCell(currentUser: UserModel) {
        
        fullName.text = currentUser.fullName
        email.text = currentUser.email
        username.text = currentUser.username
        
        let userTypeString = currentUser.userType.rawValue
        self.userType.text = userTypeString
        
    }
    
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        segmentedControlHandler?(sender.selectedSegmentIndex)
    }
}
