//
//  SideMenuTableViewCell.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var sideMenuItem:SideMenuItem? {
        didSet {
            titleLabel.text = sideMenuItem?.title
            iconView.image = sideMenuItem?.image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView = UIView()
    }
}
