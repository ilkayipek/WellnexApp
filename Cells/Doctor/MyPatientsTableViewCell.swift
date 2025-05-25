//
//  MyPatientsTableViewCell.swift
//  WellnexApp
//
//  Created by MacBook on 26.05.2025.
//

import UIKit

class MyPatientsTableViewCell: UITableViewCell {
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var relationDate: UILabel!
    @IBOutlet weak var profileImage: CustomUIImageView!
    @IBOutlet weak var relationshipNote: UILabel!
    @IBOutlet weak var containerView: CustomContainerUIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
       
    }
    
    func loadCell(_ relation: PatientDoctorRelationshipModel) {
        fullName.text = relation.patientName
        relationDate.text = relation.createdAt.getDayMonthYear()
        relationshipNote.text = relation.notes
    }
    
}
