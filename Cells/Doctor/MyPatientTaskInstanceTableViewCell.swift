//
//  MyPatientTaskInstanceTableViewCell.swift
//  WellnexApp
//
//  Created by MacBook on 26.05.2025.
//

import UIKit

class MyPatientTaskInstanceTableViewCell: UITableViewCell {
    @IBOutlet weak var measureImageView: CustomUIImageView!
    @IBOutlet weak var measureLabel: UILabel!
    @IBOutlet weak var slotHourRange: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var containerView: CustomContainerUIView!
    @IBOutlet weak var assignedByLabel: UILabel!
    @IBOutlet weak var measureValueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func loadCell(_ model: TaskInstanceModel){
        self.selectionStyle = .none
        guard let measureTypeModel = model.measureTypeModel else { return }
        
        let measureTypeLbl = measureTypeModel.label
        assignedByLabel.text = model.assignedBy
        
        let measureValue = "\(model.value ?? 0.0) \(measureTypeModel.unit ?? "")"
        measureValueLabel.text = measureValue
        
        measureLabel.text = measureTypeLbl?.rawValue
        slotHourRange.text = model.slot
        
        completedButton.isHidden = !model.isCompleted
        measureImageView.loadMeasureTypeImage(measureTypeModel.label ?? .bodyTemperature)
        
        if model.isOverdue{
            containerView.borderColor = UIColor.red
            
        } else if model.isInProgress{
            containerView.borderColor = UIColor.activePrimaryButton
        } else if model.isCompleted{
            containerView.borderColor = UIColor.activePrimaryButton
        } else {
            containerView.borderColor = UIColor.systemYellow
        }
        
                
    }
    
}
