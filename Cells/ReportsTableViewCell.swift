//
//  ReportsTableViewCell.swift
//  WellnexApp
//
//  Created by MacBook on 28.05.2025.
//

import UIKit


class ReportsTableViewCell: UITableViewCell {
    @IBOutlet weak var measureTypeImageView: CustomUIImageView!

    @IBOutlet weak var customCircularProgressView: CustomCircularProgressView!
    @IBOutlet weak var circularProgressViewContainer: UIView!
    @IBOutlet weak var measureLabel: UILabel!
    
    @IBOutlet weak var reportStatusButton: UIButton!
    @IBOutlet weak var arrowButton: UIButton!

    @IBOutlet weak var assignedByLabel: UILabel!
    @IBOutlet weak var assignedToLabel: UILabel!

    @IBOutlet weak var taskDateRange: UILabel!
    @IBOutlet weak var dateLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func loadCell(_ reportModel: ReportModel) {
        let rate = CGFloat(reportModel.completionRate ?? 0)/100
        customCircularProgressView.setProgress(to: rate)
        dateLabel.text = reportModel.createdAt.getDayMonthYear()
        
        if reportModel.isComplete {
            reportStatusButton.isHidden = true
            circularProgressViewContainer.isHidden = false
            arrowButton.isHidden = false
        }else {
            reportStatusButton.isHidden = false
            circularProgressViewContainer.isHidden = true
            arrowButton.isHidden = true
        }
        
        guard let task = reportModel.taskModel else {return}
        
        assignedByLabel.text = task.assignedBy
        assignedToLabel.text = task.assignedTo
        
        let range = "\(task.startDate.getDayMonthYear())-\(task.endDate.getDayMonthYear())"
        taskDateRange.text = range
        
        guard let measureModel = reportModel.taskModel?.measureTypeModel else {return}
        
        let measureTxt = "\(measureModel.label?.rawValue ?? "") Ölçümü"
        measureLabel.text = measureTxt
        measureTypeImageView.loadMeasureTypeImage(measureModel.label ?? .pulse)
    }
    
}
