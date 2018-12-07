//
//  ReviewTableViewCell.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/14/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import Cosmos

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var orgName: UILabel!
    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var parentVu: UIView!
    @IBOutlet weak var orgImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //orgImage.layer.cornerRadius = orgImage.frame.height / 2
        orgImage.layer.cornerRadius = 30 // orgImage.bounds.height / 2
        
        parentVu.backgroundColor = .white
        parentVu.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0.1176470588, alpha: 1)
        parentVu.layer.shadowRadius = 4
        parentVu.layer.shadowOpacity = 0.3
        parentVu.layer.shadowOffset = CGSize(width: -2, height: 0.5)
        parentVu.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
