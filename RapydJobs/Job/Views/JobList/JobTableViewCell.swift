//
//  JobTableViewCell.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/3/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {
    
    @IBOutlet weak var parentVu: UIView!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var editJob: UIButton!{
        didSet {
            actionStyle(editJob, UIImage(named: "ic_interviews")!) //ic_edit
            editJob.titleEdgeInsets = UIEdgeInsetsMake(0, -20.5, 0, 0)            
        }
    }
    @IBOutlet weak var stopJob: UIButton! {
        didSet {
            actionStyle(stopJob, UIImage(named: "close")!) //ic_interviews
            stopJob.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0) //-17.5
        }
    }
    
    var editJobCompletion: (() -> Void)?
    var stopJobCompletion: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
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
    
    @IBAction func editJobTapped(_ sender: UIButton) {
        self.editJobCompletion?()
    }
    
    @IBAction func stopJobTapped(_ sender: UIButton) {
        self.stopJobCompletion?()
    }
    
}
