//
//  ProfileInfoTableViewCell.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 1/26/19.
//  Copyright © 2019 chymps. All rights reserved.
//

import UIKit

class ProfileInfoTableViewCell: ShdaowBaseTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
