//
//  ScheduledTableViewCell.swift
//  RapydJobs
//
//  Created by Maroof Khan on 15/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class ScheduledTableViewCell: ShdaowBaseTableViewCell {
    @IBOutlet weak var displayImageView: UIImageView! {
        didSet { displayStyle(displayImageView) }
    }
    @IBOutlet weak var timeLabel: UILabel! {
        didSet { timeStyle(timeLabel) }
    }
    @IBOutlet weak var nameLabel: UILabel! {
        didSet { titleStyle(nameLabel) }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet { jobTitleStyle(titleLabel) }
    }
    @IBOutlet weak var rescheduleButton: UIButton! {
        didSet {
            actionStyle(rescheduleButton, UIImage(named: "ic_interviews")!)
            rescheduleButton.setTitle("Reschedule", for: .normal)
            rescheduleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -17.5, 0, 0)
        }
    }
    @IBOutlet weak var interviewButton: UIButton! {
        didSet {
            actionStyle(interviewButton, UIImage(named: "ic_tick_green")!)
            interviewButton.setTitle("Interview Done", for: .normal)
            interviewButton.titleEdgeInsets = UIEdgeInsetsMake(0, -17.5, 0, 0)
        }
    }
    
    var updateInterviewCompletion: (() -> Void)?
    var rescheduleInterviewCompletion: (() -> Void)?
    
    @IBAction func updateInterview(_ sender: UIButton) {
        updateInterviewCompletion?()
    }
    
    @IBAction func rescheduleInterview(_ sender: UIButton) {
        rescheduleInterviewCompletion?()
    }
    
    func update(_ data: InterviewModel) {
        //data.profileImage
        print(data.toJSON())
        displayImageView.setImageWithName(data.profileImage!, isCompleteUrl: true)
        let startTime = data.startTime ?? ""
        let endTime = data.endTime ?? ""
        timeLabel.text =  "\(String(describing: startTime)) - \(String(describing: endTime))"
        nameLabel.text = data.fullname
        titleLabel.text = data.jobTitle
    }
    
    func setup(viewModel: ScheduledInterviewViewModel) {
        displayImageView.image = UIImage(named: "face.jpg")
        timeLabel.text = viewModel.time.string
        nameLabel.text = viewModel.candidate.name
        titleLabel.text = viewModel.candidate.title
    }
}
