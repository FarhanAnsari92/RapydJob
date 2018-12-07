//
//  ProfileDetailsTableReviewCell.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 25/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import Cosmos

class ProfileDetailsTableReviewCell: ShdaowBaseTableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        self.profileImageView.layer.borderColor = UIColor.gray.cgColor
        self.profileImageView.layer.borderWidth = 1
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width/2
        self.profileImageView.layer.masksToBounds = true
    }
    
    func populateWithReviewModel(_ review:ProfileReviewModel) {
        self.nameLabel.text = review.name
        self.descriptionLabel.text = review.comments
        self.profileImageView.image = review.image
        self.ratingView.rating = review.rating
    }
}
