//
//  DayOfWeekCollectionViewCell.swift
//  WellnexApp
//
//  Created by MacBook on 14.05.2025.
//

import UIKit

class DaySelectionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dayButton: CustomUIButton!
    
    var dayButtonTappedHandler: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
    func loadCell(with dayOfWeek: String, status: Bool) {
        
        dayButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        dayButton.setTitle(dayOfWeek, for: .normal)
        dayButton.setTitle(dayOfWeek, for: .selected)
        dayButton.setTitleColor(.white, for: .selected)
        
        setSelection(status: status)
        
        dayButton.layer.shadowColor = UIColor.black.cgColor  // Gölgenin rengi
        dayButton.layer.shadowOpacity = 0.4               // Saydamlık (0.0 - 1.0)
        dayButton.layer.shadowOffset = CGSize(width: 0, height: 3) // Gölgenin yönü
        dayButton.layer.shadowRadius = 5                     // Gölgenin bulanıklık miktarı
        dayButton.layer.masksToBounds = false                // Gölgenin kesilmemesi için gerekli

    }
    
    private func setSelection(status: Bool) {
        dayButton.isSelected = status
        
        if dayButton.isSelected {
            dayButton.layer.shadowColor = UIColor.activePrimaryButtonColor.cgColor
            dayButton.backgroundColor = .activePrimaryButtonColor
            dayButton.borderColor = .activePrimaryButtonColor
        } else {
            dayButton.layer.shadowColor = UIColor.black.cgColor
            dayButton.backgroundColor = .clear
            dayButton.borderColor = .black
        }
        
    }

    @IBAction func dayButtonTapped(_ sender: Any) {
        dayButtonTappedHandler?()
    }
}
