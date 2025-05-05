//
//  MyProfileDetailTableViewCell.swift
//  WellnexApp
//
//  Created by MacBook on 4.05.2025.
//

import UIKit

class MyProfileDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userType: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var addPatientButton: CustomUIButton!
    
    var addPatientButtonHandler: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func loadCell(currentUser: UserModel) {
        
        fullName.text = currentUser.fullName
        email.text = currentUser.email
        username.text = currentUser.username
        
        let userTypeString = currentUser.userType
        self.userType.text = userTypeString
        let userTypeEnum = UserType(rawValue: userTypeString) ?? .patient
        
        userImage.image = UIImage(named: userTypeString)
        
        if userTypeEnum == .doctor {
            addPatientButton.isHidden = false
            addPatientButton.isEnabled = true
        } else {
            addPatientButton.isHidden = true
            addPatientButton.isEnabled = false
        }
        
    }
    
    @IBAction func addPatientButtonTapped(_ sender: Any) {
        addPatientButtonHandler?()
    }
}
