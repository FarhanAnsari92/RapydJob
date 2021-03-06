//
//  CardViewCell.swift
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
    @IBOutlet weak var descriptionHeadLabel: UILabel!
    @IBOutlet weak var attributesStackView: UIStackView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var jobshiftTiming: UIStackView!
    @IBOutlet weak var lblDates: UILabel!
    var shidTimingCompletion: (() -> Void)?
    
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 25
        self.contentView.layer.masksToBounds = false
        self.contentView.layer.shadowRadius = 10
        self.contentView.layer.shadowColor = Constants.Colors.primaryBlueColor.cgColor
        self.contentView.layer.shadowOpacity = 0.3
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapAtDates))
        lblDates.addGestureRecognizer(gesture)

        self.imageView.layer.cornerRadius = self.imageView.bounds.size.width/2
        self.imageView.layer.masksToBounds = true
        self.lblDates.isUserInteractionEnabled = true
        if AppContainer.shared.user.user?.accountType == "organization" {
            self.lblDates.text = "View Candidate's Availability"
            
            if EditProfileFlowManager.shared().isHomeScreen {
                self.noDataLabel.text = "NO SEEKERS FOR THIS JOB"
            } else {
                self.noDataLabel.text = "NO SEEKERS SHORTLISTED"
            }            
        } else {
            self.jobshiftTiming.isHidden = true
            self.lblDates.text = "View Shift Timing"
            if EditProfileFlowManager.shared().isHomeScreen {
                
                self.noDataLabel.text = "NO JOBS FOUND"
            } else {
                self.noDataLabel.text = "NO JOBS SHORTLISTED"
            }
            
        }
    }
    
    @objc func tapAtDates() {
        self.shidTimingCompletion?()
    }
    
    func populateWithCardItem(_ cardItem:CardViewItem) {
        print(cardItem)
        self.imageView.setImageWithName(cardItem.imageName)
        self.nameLabel.text = cardItem.title
        self.subtitleLabel.text = cardItem.subtitle
        self.ratingView.rating = cardItem.rating
        self.descriptionLabel.text = cardItem.description
        self.jobTitleLabel.text = cardItem.jobTitle
        self.educationLabel.text = cardItem.education
        self.locationLabel.text = cardItem.location
        shouldHideAllViews(cardItem.shouldHide)
    }
    
    func populateWithCardItem(_ cardItem:Any?) {
        guard let data = cardItem as? [String:Any] else {
            self.shouldHideAllViews(true)
            return
        }
        print(data)
        
        if AppContainer.shared.user.user?.accountType ?? "" == "jobseeker" {
            let profileImage = data["profile_image"] as? String ?? ""
            let title = data["title"] as? String ?? ""
            let organizationName = data["organization_name"] as? String ?? ""
            let description = data["description"] as? String ?? ""
            let minSalary = data["min_salary"] as? Int ?? 0
            let maxSalary = data["max_salary"] as? Int ?? 0
            
            let addressDetail = data["address"] as? [String: Any] ?? [String: Any]()
            let address = addressDetail["address"] as? String ?? "Not Provided"
            
            self.imageView.setImageWithName(profileImage)
            self.nameLabel.text = title
            self.subtitleLabel.text = organizationName
            self.ratingView.rating = 0
            self.descriptionLabel.text = description
            self.jobTitleLabel.text = "£\(minSalary) - £\(maxSalary) Per Hour Rate"
            self.educationLabel.text = "View Shift Timing"
            self.locationLabel.text = address
            
            let shouldHide = data["shouldHide"] as? Bool ?? false
            self.shouldHideAllViews(shouldHide)
        } else {
            let profileImage = data["profile_image"] as? String ?? ""
            self.imageView.setImageWithName(profileImage)
            
            if let education = data["education"] as? [String: Any],
                let educationDesc = education["title"] as? String {
                self.educationLabel.text = educationDesc
            }
            
            if let address = data["address"] as? [String:Any],
                let completeAddress = address["address"] as? String {
                self.locationLabel.text = completeAddress
            }
            
            if let experience = data["experience"] as? [String:Any],
                let _ = experience["description"] as? String,
                let jobTitle = experience["title"] as? String {
                self.jobTitleLabel.text = jobTitle
            }
            
            if let jobSeeker = data["job_seeker"] as? [String:Any],
                let fullName = jobSeeker["fullname"] as? String,
            let description = jobSeeker["description"] as? String {
                self.nameLabel.text = fullName
                self.descriptionLabel.text = description
            }
            let shouldHide = data["shouldHide"] as? Bool ?? false
            self.shouldHideAllViews(shouldHide)
        }
        
        
//        self.imageView.setImageWithName(cardItem.imageName)
//        self.nameLabel.text = cardItem.title
//        self.subtitleLabel.text = cardItem.subtitle
//        self.ratingView.rating = cardItem.rating
//        self.descriptionLabel.text = cardItem.description
//        self.jobTitleLabel.text = cardItem.jobTitle
//        self.educationLabel.text = cardItem.education
//        self.locationLabel.text = cardItem.location
//        shouldHideAllViews(cardItem.shouldHide)
        
    }
    
    func shouldHideAllViews(_ flag:Bool) {
        self.imageView.alpha = flag ? 0 : 1
        self.nameLabel.alpha = flag ? 0 : 1
        self.subtitleLabel.alpha = flag ? 0 : 1
        self.ratingView.alpha = flag ? 0 : 1
        self.descriptionHeadLabel.alpha = flag ? 0 : 1
        self.descriptionLabel.alpha = flag ? 0 : 1
        self.jobTitleLabel.alpha = flag ? 0 : 1
        self.educationLabel.alpha = flag ? 0 : 1
        self.locationLabel.alpha = flag ? 0 : 1
        self.attributesStackView.alpha = flag ? 0 : 1
        self.noDataLabel.alpha = flag ? 1 : 0
    }
}
