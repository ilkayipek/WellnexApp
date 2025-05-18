//
//  HourSelectionCollectionViewCell.swift
//  WellnexApp
//
//  Created by MacBook on 17.05.2025.
//

import UIKit

class HourSelectionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hourButton: CustomUIButton!
    
    var hourButtonTappedHandler: ((Bool) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func loadCell(with hourSlot: String, status: Bool) {
        
        hourButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        hourButton.setTitle(hourSlot, for: .normal)
        hourButton.setTitle(hourSlot, for: .selected)
        hourButton.setTitleColor(.white, for: .selected)
        
        setSelection(status: status)
        
        hourButton.layer.shadowColor = UIColor.black.cgColor  // Gölgenin rengi
        hourButton.layer.shadowOpacity = 0.4               // Saydamlık (0.0 - 1.0)
        hourButton.layer.shadowOffset = CGSize(width: 0, height: 3) // Gölgenin yönü
        hourButton.layer.shadowRadius = 5                     // Gölgenin bulanıklık miktarı
        hourButton.layer.masksToBounds = false                // Gölgenin kesilmemesi için gerekli

    }
    
    private func setSelection(status: Bool) {
        hourButton.isSelected = status
        
        if hourButton.isSelected {
            hourButton.layer.shadowColor = UIColor.activePrimaryButtonColor.cgColor
            hourButton.backgroundColor = .activePrimaryButtonColor
            hourButton.borderColor = .activePrimaryButtonColor
        } else {
            hourButton.layer.shadowColor = UIColor.black.cgColor
            hourButton.backgroundColor = .clear
            hourButton.borderColor = .black
        }
        
    }

    @IBAction func hourButtonTapped(_ sender: Any) {
        hourButton.isSelected.toggle()
        let status = hourButton.isSelected
        
        setSelection(status: status)
        hourButtonTappedHandler?(status)
    }

}
