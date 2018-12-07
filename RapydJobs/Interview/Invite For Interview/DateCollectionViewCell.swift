//
//  DateCollectionViewCell.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/1/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import AFDateHelper

class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override var isSelected: Bool {
        didSet {
            self.contentView.backgroundColor = isSelected ? AppConstants.shared.buttonGradientEnd : .clear
        }
    }
    
    func updateData(date: Date) {
        let strDate = date.toString(format: DateFormatType.custom("E d"))
        let day = strDate.split(separator: " ").first ?? ""
        let date = strDate.split(separator: " ").last ?? ""
        self.dayLabel.text = String(day)
        self.dateLabel.text = String(date)
    }
    
}
