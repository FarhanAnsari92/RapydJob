//
//  ShowTimeSheetTableViewCell.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 3/31/19.
//  Copyright © 2019 chymps. All rights reserved.
//

import UIKit

class ShowTimeSheetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
