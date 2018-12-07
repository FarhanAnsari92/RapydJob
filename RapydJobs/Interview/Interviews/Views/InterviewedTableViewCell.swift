//
//  InterviewedTableViewCell.swift
//  RapydJobs
//
//  Created by Maroof Khan on 15/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class InterviewedTableViewCell: ShdaowBaseTableViewCell {
    @IBOutlet weak var displayImageView: UIImageView! {
        didSet { displayStyle(displayImageView) }
    }
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet { titleStyle(nameLabel) }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet { jobTitleStyle(titleLabel) }
    }
    @IBOutlet weak var hireButton: UIButton! {
        didSet {
            actionStyle(hireButton, UIImage(named: "ic_tick_green")!)
            hireButton.setTitle("Hire", for: .normal)
            hireButton.titleEdgeInsets = UIEdgeInsetsMake(0, -17.5, 0, 0)
        }
    }
    @IBOutlet weak var rejectButton: UIButton! {
        didSet {
            actionStyle(rejectButton, UIImage(named: "ic_cross_big")!)
            rejectButton.setTitle("Reject", for: .normal)
            rejectButton.titleEdgeInsets = UIEdgeInsetsMake(0, -17.5, 0, 0)
        }
    }
    
    var makeOfferCompletion: (() -> Void)?
    var rejectOfferCompletion: (() -> Void)?
    
    @IBAction func makeOffer(_ sender: UIButton) {
        makeOfferCompletion?()
    }
    
    @IBAction func reject(_ sender: UIButton) {
        rejectOfferCompletion?()
    }
    
    func update(_ data: InterviewModel) {        
        displayImageView.setImageWithName(data.profileImage!, isCompleteUrl: true)
        //timeLabel.text = data.endTime
        nameLabel.text = data.fullname
        titleLabel.text = data.jobTitle
    }
    
    func setup(viewModel: InterviewedCandidateViewModel) {
        displayImageView.image = UIImage(named: "face.jpg")
        nameLabel.text = viewModel.candidate.name
        titleLabel.text = viewModel.candidate.title
    }
}
