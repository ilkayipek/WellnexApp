//
//  TaskInstanceTableViewCell.swift
//  WellnexApp
//
//  Created by MacBook on 20.05.2025.
//

import UIKit

class TaskInstanceTableViewCell: UITableViewCell {
    @IBOutlet weak var measureImageView: CustomUIImageView!
    @IBOutlet weak var measureLabel: UILabel!
    @IBOutlet weak var slotHourRange: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var editableButton: UIButton!
    @IBOutlet weak var containerView: CustomContainerUIView!
    @IBOutlet weak var assignedByLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func loadCell(_ model: TaskInstanceModel){
        self.selectionStyle = .none
        let measureTypeLbl = model.measureTypeModel?.label
        assignedByLabel.text = model.assignedBy
        
        measureLabel.text = measureTypeLbl?.rawValue
        slotHourRange.text = model.slot
        
        completedButton.isHidden = !model.isCompleted
        
        if model.isOverdue{
            containerView.borderColor = UIColor.red
            editableButton.isHidden = true
            
        } else if model.isInProgress{
            containerView.borderColor = UIColor.activePrimaryButton
            editableButton.isHidden = false
            
        } else if model.isCompleted{
            containerView.borderColor = UIColor.activePrimaryButton
            editableButton.isHidden = true
            
        } else {
            containerView.borderColor = UIColor.systemYellow
            editableButton.isHidden = true
        }
        
        switch measureTypeLbl {
        case .bloodSugar:
            measureImageView.loadImageFromAssets(.bloodSugar)
        case .pulse:
            measureImageView.loadImageFromAssets(.pulse)
        case .bodyTemperature:
            measureImageView.loadImageFromAssets(.bodyTemperature)
        case .bloodPressure:
            measureImageView.loadImageFromAssets(.bloodPressure)
        case .none:
            print("none")
        }
        
    }
    
}
