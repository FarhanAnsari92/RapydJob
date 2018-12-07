//
//  CardView.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 24/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import Cosmos

class CardViewCell: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 25
        self.contentView.layer.masksToBounds = false
        self.contentView.layer.shadowRadius = 10
        self.contentView.layer.shadowColor = Constants.Colors.primaryBlueColor.cgColor
        self.contentView.layer.shadowOpacity = 0.3
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 5)

        self.imageView.layer.cornerRadius = self.imageView.bounds.size.width/2
        self.imageView.layer.masksToBounds = true
    }
    
    func populateWithCardItem(_ cardItem:CardViewItem) {
        self.imageView.image = cardItem.image
        self.nameLabel.text = cardItem.title
        self.subtitleLabel.text = cardItem.subtitle
        self.ratingView.rating = cardItem.rating
        self.descriptionLabel.text = cardItem.description
        self.jobTitleLabel.text = cardItem.jobTitle
        self.educationLabel.text = cardItem.education
        self.locationLabel.text = cardItem.location
        shouldHideAllViews(cardItem.shouldHide)
    }
    
    private func shouldHideAllViews(_ flag:Bool) {
        self.imageView.alpha = flag ? 0 : 1
        self.nameLabel.alpha = flag ? 0 : 1
        self.subtitleLabel.alpha = flag ? 0 : 1
        self.ratingView.alpha = flag ? 0 : 1
        self.descriptionLabel.alpha = flag ? 0 : 1
        self.jobTitleLabel.alpha = flag ? 0 : 1
        self.educationLabel.alpha = flag ? 0 : 1
        self.locationLabel.alpha = flag ? 0 : 1
    }
}
