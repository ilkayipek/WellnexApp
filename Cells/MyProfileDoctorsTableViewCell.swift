//
//  MyProfileDoctorsTableViewCell.swift
//  WellnexApp
//
//  Created by MacBook on 4.05.2025.
//

import UIKit

class MyProfileDoctorsTableViewCell: UITableViewCell {
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var relationStatus: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var profileImage: CustomUIImageView!
    @IBOutlet weak var relationshipNote: UILabel!
    @IBOutlet weak var containerView: CustomContainerUIView!
    
    var acceptButtonHandler: (() -> Void)?
    var rejectButtonHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    func loadCell(relationshipModel: PatientDoctorRelationshipModel) {
        fullName.text = relationshipModel.doctorName
        relationStatus.text = relationshipModel.status
        relationshipNote.text = relationshipModel.notes
        
        let statusEnum = RelationshipStatus(rawValue: relationshipModel.status) ?? .pending
        
        switch statusEnum {
        case .pending:
            
            pendingButtonsActive()
            containerView.borderColor = UIColor.lightGray
        case .accepted:
            
            pendingButtonsInactive()
            containerView.borderColor = UIColor.systemGreen
        case .rejected:
            
            pendingButtonsInactive()
            containerView.borderColor = UIColor.systemRed
        }
    }
    
    private func pendingButtonsActive() {
        acceptButton.isHidden = false
        acceptButton.isEnabled = true
        rejectButton.isHidden = false
        rejectButton.isEnabled = true
    }
    
    private func pendingButtonsInactive() {
        acceptButton.isHidden = true
        acceptButton.isEnabled = false
        rejectButton.isHidden = true
        rejectButton.isEnabled = false
    }
    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        acceptButtonHandler?()
        
    }
    
    @IBAction func rejectButtonTapped(_ sender: Any) {
        rejectButtonHandler?()
    }
}
