//
//  MyProfilePatientsTableViewCell.swift
//  WellnexApp
//
//  Created by MacBook on 5.05.2025.
//

import UIKit

class MyProfilePatientsTableViewCell: UITableViewCell {
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var relationStatus: UILabel!
    @IBOutlet weak var profileImage: CustomUIImageView!
    @IBOutlet weak var relationshipNote: UILabel!
    @IBOutlet weak var containerView: CustomContainerUIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func loadCell(relationshipModel: PatientDoctorRelationshipModel) {
        fullName.text = relationshipModel.patientName
        relationStatus.text = relationshipModel.status.rawValue
        relationshipNote.text = relationshipModel.notes
        
        switch relationshipModel.status {
        case .pending:
            
            containerView.borderColor = UIColor.lightGray
        case .accepted:
            
            containerView.borderColor = UIColor.systemGreen
        case .rejected:
            
            containerView.borderColor = UIColor.systemRed
        }
    }
    
}
