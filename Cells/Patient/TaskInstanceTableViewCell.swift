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

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func loadCell(_ model: TaskInstanceModel){
        self.selectionStyle = .none
        let measureTypeLbl = model.measureTypeModel?.label
        
        measureLabel.text = measureTypeLbl?.rawValue
        slotHourRange.text = model.slot
        
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
