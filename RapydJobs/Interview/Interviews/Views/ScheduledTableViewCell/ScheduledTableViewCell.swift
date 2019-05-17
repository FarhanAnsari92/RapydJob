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
    @IBOutlet weak var dateLabel: UILabel! {
        didSet { timeStyle(dateLabel) }
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
    var profilePictureCompletion: (() -> Void)?
    
    @IBAction func updateInterview(_ sender: UIButton) {
        updateInterviewCompletion?()
    }
    
    @IBAction func rescheduleInterview(_ sender: UIButton) {
        rescheduleInterviewCompletion?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.displayImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapAtPicture))
        self.nameLabel.isUserInteractionEnabled = true
        self.displayImageView.addGestureRecognizer(tapGesture)
        self.nameLabel.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func tapAtPicture() {
        self.profilePictureCompletion?()
    }
    
    func update(_ data: InterviewModel) {
        //data.profileImage
        print(data.toJSON())
        displayImageView.setImageWithName(data.profileImage!, isCompleteUrl: true)
        let startTime = data.startTime ?? ""
        let endTime = data.endTime ?? ""
        let date = data.date ?? ""
        
        let formatString = "E, MMMM dd, yyyy"
        let df = DateFormatter(withFormat: "dd-MM-yyyy", locale: "en_US_POSIX")
        let dt = df.date(from: date) ?? Date()
        df.dateFormat = formatString
        let strDate = df.string(from: dt)
        
        timeLabel.text =  "\(String(describing: startTime)) - \(String(describing: endTime))"
        nameLabel.text = data.fullname
        titleLabel.text = data.jobTitle
        dateLabel.text = strDate // "Interview Date: \(date)"
    }
    
    func setup(viewModel: ScheduledInterviewViewModel) {
        displayImageView.image = #imageLiteral(resourceName: "Placeholder")
        timeLabel.text = viewModel.time.string
        nameLabel.text = viewModel.candidate.name
        titleLabel.text = viewModel.candidate.title
    }
}
