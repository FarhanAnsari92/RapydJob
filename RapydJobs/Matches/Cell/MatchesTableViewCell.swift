//
//  MatchesTableViewCell.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 01/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

protocol MatchesTableViewCellDelegate: class {
    func didTapMessageButtonOnCell(_ cell:MatchesTableViewCell)
}

class MatchesTableViewCell: ShdaowBaseTableViewCell {

    weak var delegate: MatchesTableViewCellDelegate?
    
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        self.messageBtn.contentMode = .center
        self.messageBtn.imageView?.contentMode = .scaleAspectFit
        let insets: CGFloat = 10
        self.messageBtn.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)

        self.iconView.layer.cornerRadius = self.iconView.bounds.size.width/2
        self.iconView.layer.masksToBounds = true
    }
    
    func populateWithJobMatchModel(_ model: JobMatch) {
        self.iconView.setImageWithName(model.profileImage)
        self.titleLabel.text = model.username.capitalized
        self.subtitleLabel.text = model.email.lowercased()
    }
    
    func populateWithJobseekerMatchModel(_ model: JobMatches) {
        self.iconView.setImageWithName(model.jobOwner.profileImage)
        self.titleLabel.text = model.title.capitalized
        self.subtitleLabel.text = model.jobOwner.username
    }
    
    @IBAction func didTapMessageButton(_ sender: Any) {
        self.delegate?.didTapMessageButtonOnCell(self)
    }
}
