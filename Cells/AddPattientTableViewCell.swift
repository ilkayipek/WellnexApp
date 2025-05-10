//
//  AddPattientTableViewCell.swift
//  WellnexApp
//
//  Created by MacBook on 9.05.2025.
//

import UIKit

class AddPattientTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addPatientButton: CustomUIButton!
    
    var addPatientHandler: (()->Void)?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func loadCell(user: UserModel) {
        nameLabel.text = user.fullName
        usernameLabel.text = "@\(user.username)"
    }
    
    @IBAction func addPatientButtonTapped(_ sender: Any) {
        addPatientHandler?()
    }
}
