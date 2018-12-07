//
//  ScheduleInterviewTableViewCell.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/8/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class ScheduleInterviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var parentVu: UIView!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var organizationPicture: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.organizationPicture.layer.cornerRadius = 30.0
        
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
    
    func updateData(_ data: [String:Any]) {
        self.jobTitle.text = data["organizationName"] as? String ?? ""
        self.date.text = data["date"] as? String ?? ""
        self.time.text = data["time"] as? String ?? ""
            
        self.organizationPicture.setImageWithName(data["organizationPicture"] as? String ?? "")
        
    }
    
}
