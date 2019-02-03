//
//  SideMenuTableViewCell.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notificationView: UIView!
    
    var sideMenuItem:SideMenuItem? {
        didSet {
            titleLabel.text = sideMenuItem?.title
            iconView.image = sideMenuItem?.image
            switch sideMenuItem?.title {
                //seeker
            case "Scheduled Interviews":
                self.notificationView.isHidden = !(AppContainer.shared.notificationContainer.InterviewSchedule)
            case "Job Offers":
                self.notificationView.isHidden = !(AppContainer.shared.notificationContainer.JobOfferSend)
            case "Jobseeker Timesheet":
                self.notificationView.isHidden = !(AppContainer.shared.notificationContainer.JobSeekerTimesheet)
                
                //Employeer
            case "Employer Timesheet":
                self.notificationView.isHidden = !(AppContainer.shared.notificationContainer.OrganisationTimesheet)
            case "HR":
                self.notificationView.isHidden = !(AppContainer.shared.notificationContainer.JobOfferResponse)                
            default:
                self.notificationView.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView = UIView()
        self.notificationView.layer.cornerRadius = 5
    }
}
