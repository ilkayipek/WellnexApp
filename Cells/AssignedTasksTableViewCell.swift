//
//  TasksAndDetailsTableViewCell.swift
//  WellnexApp
//
//  Created by MacBook on 23.05.2025.
//

import UIKit

class AssignedTasksTableViewCell: UITableViewCell {
    @IBOutlet weak var measureTypeImageView: CustomUIImageView!
    @IBOutlet weak var measureTypeLabel: UILabel!
    @IBOutlet weak var assignedByLabel: UILabel!
    @IBOutlet weak var startAndEndDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func loadCell(_ task: TaskModel) {
        
        let startDateStr = task.startDate.getDayMonthYear()
        let endDateStr = task.endDate.getDayMonthYear()
        
        startAndEndDateLabel.text =  "\(startDateStr) - \(endDateStr)"
        assignedByLabel.text = task.assignedBy
        
        let measureTypeEnum = task.measureTypeModel?.label
        measureTypeLabel.text = "\(measureTypeEnum?.rawValue ?? "") Ölçümü"
        
        guard let measureTypeEnum = measureTypeEnum else { return }
        measureTypeImageView.loadMeasureTypeImage(measureTypeEnum)
    }
    
}
