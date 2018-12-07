//
//  RelatedFieldsCollectionViewCell.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 01/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class RelatedFieldsCollectionViewCell: UICollectionViewCell {

    let inactiveColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1)
    let activeColor = UIColor(red: 123/255.0, green: 182/255.0, blue: 174/255.0, alpha: 1)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    func updateData(_ data: Sector) {
        
        self.titleLabel.text = data.sectorTitle
        self.iconView.image = UIImage(named: data.sectorImage)
        
        if data.isSelected {
            self.titleLabel.textColor = activeColor
            self.iconView.tintColor = UIColor.clear
            self.iconView.image = iconView.image?.withRenderingMode(.alwaysOriginal)
        } else {
            self.titleLabel.textColor = inactiveColor
            self.iconView.tintColor = inactiveColor
            self.iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
        }
    }

    func populateWithCellModel(_ model: RelatedFieldsCellModel) {
        self.titleLabel.text = model.title
        self.iconView.image = model.image
        
        switch model.isActive {
        case false:
            self.titleLabel.textColor = inactiveColor
            self.iconView.tintColor = inactiveColor
            self.iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
        case true:
            self.titleLabel.textColor = activeColor
            self.iconView.tintColor = UIColor.clear
            self.iconView.image = iconView.image?.withRenderingMode(.alwaysOriginal)
        }
    }
}
