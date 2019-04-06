//
//  JobOfferTableViewCell.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/7/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class JobOfferTableViewCell: UITableViewCell {
    
    @IBOutlet weak var parentVu: UIView!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var jobOrganizationName: UILabel!
    @IBOutlet weak var jobSeekerImage: UIImageView!
    @IBOutlet weak var jobTitle: UILabel!
    
    var timeSheetCompletion: (() -> Void)?
    var acceptCompletion: (() -> Void)?
    var rejectCompletion: (() -> Void)?
    var profilePictureCompletion: (() -> Void)?
    
    @IBOutlet weak var makeTimesheet: UIButton! {
        didSet {
            actionStyle(makeTimesheet, UIImage(named: "ic_interviews")!)
            makeTimesheet.titleEdgeInsets = UIEdgeInsetsMake(0, -17.5, 0, 0)
        }
    }
    @IBOutlet weak var accept: UIButton! {
        didSet {
            actionStyle(accept, UIImage(named: "ic_tick_green")!)
            accept.titleEdgeInsets = UIEdgeInsetsMake(0, -17.5, 0, 0)
        }
    }
    @IBOutlet weak var reject: UIButton! {
        didSet {
            actionStyle(reject, UIImage(named: "ic_cross_big")!)
            reject.titleEdgeInsets = UIEdgeInsetsMake(0, -17.5, 0, 0)
        }
    }
    
    @IBAction func btnTap(_ sender: UIButton) {
        if sender == makeTimesheet {
            timeSheetCompletion?()
        } else if sender == accept {
            acceptCompletion?()
        } else { // reject
            rejectCompletion?()
        }
    }
    
    @objc func tapAtImage() {
        profilePictureCompletion?()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.jobSeekerImage.layer.cornerRadius = 37.0
        self.jobSeekerImage.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapAtImage))
        self.jobSeekerImage.addGestureRecognizer(tapGesture)
        
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
    
    func updateData(_ data: JobOfferData) {
        self.jobOrganizationName.text = data.JobOfferOwnerData.username
        self.jobTitle.text = data.title
        if let img = data.JobOfferOwnerData.profileImage {
            self.jobSeekerImage.setImageWithName(img)
        } else {
            self.jobSeekerImage.image = UIImage(named: "Placeholder")
        }
    }
    
}
