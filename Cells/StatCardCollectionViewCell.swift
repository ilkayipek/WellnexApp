//
//  StatCardCollectionViewCell.swift
//  WellnexApp
//
//  Created by MacBook on 3.06.2025.
//

import UIKit

class StatCardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func loadCell(_ model: StatCardModel) {
        titleLabel.text = model.title
        valueLabel.text = model.value
        iconImageView.image = UIImage(systemName: model.imageName)
        iconImageView.tintColor = model.color
        
    }
}
