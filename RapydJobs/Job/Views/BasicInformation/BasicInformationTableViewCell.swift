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
    var shiftTimingCompletion: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UIGestureRecognizer(target: self, action: #selector(self.didtapAtTimeSheet))
        self.timeLabel.isUserInteractionEnabled = true
        self.timeLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func didtapAtTimeSheet() {
        self.shiftTimingCompletion?()
    }
    
    func setup(location: String, budget: String, time: String) {
        timeLabel.text = time
        budgetLabel.text = budget
        locationLabel.text = location
    }

}
