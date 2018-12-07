//
//  ManagedEmployeeTableViewCell.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/4/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class ManagedEmployeeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var parentVu: UIView!
    
    @IBOutlet weak var jobSeekerName: UILabel!
    @IBOutlet weak var jobSeekerImage: UIImageView!
    @IBOutlet weak var jobTitle: UILabel!
    
    @IBOutlet weak var terminateBtn: UIButton! {
        didSet {
            actionStyle(terminateBtn, UIImage(named: "ic_interviews")!)
            terminateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -17.5, 0, 0)
        }
    }
    @IBOutlet weak var renewBtn: UIButton! {
        didSet {
            actionStyle(renewBtn, UIImage(named: "ic_interviews")!)
            renewBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -17.5, 0, 0)
        }
    }
    @IBOutlet weak var deleteBtn: UIButton! {
        didSet {
            actionStyle(deleteBtn, UIImage(named: "ic_interviews")!)
            deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -17.5, 0, 0)
        }
    }
    
    var terminateCompletion: (() -> Void)?
    var renewCompletion: (() -> Void)?
    var deleteCompletion: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.jobSeekerImage.layer.cornerRadius = 37.0
        
        parentVu.backgroundColor = .white
        parentVu.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0.1176470588, alpha: 1)
        parentVu.layer.shadowRadius = 4
        parentVu.layer.shadowOpacity = 0.3
        parentVu.layer.shadowOffset = CGSize(width: -2, height: 0.5)
        parentVu.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @IBAction func btnHandler(_ sender: UIButton) {
        switch sender {
        case self.terminateBtn:
            terminateCompletion?()
        case self.renewBtn:
            renewCompletion?()
        case self.deleteBtn:
            deleteCompletion?()
        default:
            break
        }
    }
    
    func updateData(employee: ManagedEmployees) {
        self.jobSeekerName.text = employee.fullName ?? ""
        self.jobSeekerImage.setImageWithName(employee.profileImage ?? "", isCompleteUrl: true)
        self.jobTitle.text = employee.jobTitle ?? ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
