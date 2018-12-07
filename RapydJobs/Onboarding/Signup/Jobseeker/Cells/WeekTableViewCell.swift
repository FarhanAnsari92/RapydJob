//
//  WeekTableViewCell.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 12/3/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class WeekTableViewCell: UITableViewCell {

    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
