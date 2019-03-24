//
//  TimeSheetJobseekerTableViewCell.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/29/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class TimeSheetJobseekerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var parentVu: UIView!
    @IBOutlet weak var jobName: UILabel!
    @IBOutlet weak var perHour: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var totalAmount: UILabel!

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
    
    func update(data: TimesheetResponseModel) {
        self.createdAt.text = data.createdAt ?? ""
        self.jobName.text = data.jobName ?? ""
        let perHourRate = "( \(data.hourlyRate ?? "0") per hour )"
        self.perHour.text = perHourRate
        let tAmount = String(data.totalAmount ?? 0.0)
        self.totalAmount.text = "Total Amount: £\(tAmount)"
        
    }
    
}
