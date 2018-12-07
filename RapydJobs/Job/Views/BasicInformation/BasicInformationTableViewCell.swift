//
//  BasicInformationTableViewCell.swift
//  RapydJobs
//
//  Created by Maroof Khan on 08/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class BasicInformationTableViewCell: ShdaowBaseTableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    func setup(location: String, budget: String, time: String) {
        timeLabel.text = time
        budgetLabel.text = budget
        locationLabel.text = location
    }

}
