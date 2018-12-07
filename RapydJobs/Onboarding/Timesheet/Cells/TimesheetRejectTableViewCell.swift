//
//  TimesheetRejectTableViewCell.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/29/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class TimesheetRejectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var parentVu: UIView!
    @IBOutlet weak var jobName: UILabel!
    @IBOutlet weak var perHour: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var remakeBtn: UIButton! {
        didSet {
            actionStyle(remakeBtn, UIImage(named: "ic_interviews")!)
            remakeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -17.5, 0, 0)
        }
    }
    @IBOutlet weak var approveBtn: UIButton! {
        didSet {
            actionStyle(approveBtn, UIImage(named: "ic_tick_green")!)
            approveBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -17.5, 0, 0)
        }
    }
    @IBOutlet weak var rejectBtn: UIButton! {
        didSet {
            actionStyle(rejectBtn, UIImage(named: "ic_cross_big")!)
            rejectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -17.5, 0, 0)
        }
    }
    
    var remake: ((UIButton) -> Void)?
    var approve: ((UIButton) -> Void)?
    var reject: ((UIButton) -> Void)?
    
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

        // Configure the view for the selected state
    }
    
    func update(data: TimesheetResponseModel) {
        
        self.createdAt.text = data.createdAt ?? ""
        self.jobName.text = data.jobName ?? ""
        let perHourRate = "( \(data.hourlyRate ?? "0") per hour )"
        self.perHour.text = perHourRate
        let tAmount = String(data.totalAmount ?? 0.0)
        self.totalAmount.text = "Total Amount: \(tAmount)"
//        self.remakeBtn.isHidden = data.status == "reject"
//        self.separator.isHidden = data.status == "reject"
    }
    
    @IBAction func remakeBtnTap(_ sender: UIButton) {
        self.remake?(sender)
    }
    
    @IBAction func approveBtnTap(_ sender: UIButton) {
        self.approve?(sender)
    }
    
    @IBAction func rejectBtnTap(_ sender: UIButton) {
        self.reject?(sender)
    }
    
}
