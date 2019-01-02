//
//  ScheduleChatTableViewCell.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 12/31/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class ScheduleChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var receivedBubbleView: UIView! {
        didSet {
            receivedBubbleView.translatesAutoresizingMaskIntoConstraints = false
            receivedBubbleView.layer.cornerRadius = 16
            receivedBubbleView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var sentBubbleView: UIView! {
        didSet {
            sentBubbleView.translatesAutoresizingMaskIntoConstraints = false
            sentBubbleView.layer.cornerRadius = 16
            sentBubbleView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var senderScheduleBtn: UIButton!
    @IBOutlet weak var receiverScheduleBtn: UIButton!
    
    @IBOutlet weak var sentMessageDate: UILabel!
    @IBOutlet weak var receivedMessageDate: UILabel!
    
    var viewInSchedule: ((UIButton) -> Void)?
    
    class var cellIdentifier: String {
        return "ScheduleChatTableViewCellID"
    }
    
    class var cellNib: UINib {
        return UINib(nibName: "ScheduleChatTableViewCell", bundle: nil)
    }
    
    @IBAction func viewInScheduleHandler(_ sender: UIButton) {
        if sender.tag == 1 { // receiver
            self.viewInSchedule?(sender)
        } else { // sender
            self.viewInSchedule?(sender)
        }
    }
    
    func populateData(message: Message, messageType: String) {
        
        let userId = AppContainer.shared.user.user?.userId
        
        if Int(message.senderId) != userId {
            
            if messageType == "jobofferNotification" {
                
                if AppContainer.shared.user.user?.accountType == "organization" {
                    self.receiverScheduleBtn.isHidden = true
                } else {
                    self.receiverScheduleBtn.isHidden = false
                    self.receiverScheduleBtn.titleLabel?.text = "View Job Offer"
                }
                
            } else if messageType == "hireNotification" {
                
                if AppContainer.shared.user.user?.accountType == "organization" {
                    self.receiverScheduleBtn.titleLabel?.text = "Open Hired Candidate"
                } else {
                    self.receiverScheduleBtn.titleLabel?.text = "Open Hired Job"
                }
                
            } else if messageType == "interviewNotification" {
                self.receiverScheduleBtn.titleLabel?.text = "Open Schedule Interview"
            }
            
            receivedBubbleView.isHidden = false
            receivedMessageDate.isHidden = false
            
            sentBubbleView.isHidden = true
            sentMessageDate.isHidden = true
            
            receivedMessageDate.text = message.message
            
        } else {
            
            if messageType == "jobofferNotification" {
                if AppContainer.shared.user.user?.accountType == "organization" {
                    self.senderScheduleBtn.isHidden = true
                } else {
                    self.senderScheduleBtn.isHidden = false
                    self.senderScheduleBtn.titleLabel?.text = "View Job Offer"
                }
            } else if messageType == "hireNotification" {
                
                if AppContainer.shared.user.user?.accountType == "organization" {
                    self.senderScheduleBtn.titleLabel?.text = "Open Hired Candidate"
                } else {
                    self.senderScheduleBtn.titleLabel?.text = "Open Hired Job"
                }
                
            } else if messageType == "interviewNotification" {
                self.senderScheduleBtn.titleLabel?.text = "Open Schedule Interview"
            }
            
            receivedBubbleView.isHidden = true
            receivedMessageDate.isHidden = true
            
            sentBubbleView.isHidden = false
            sentMessageDate.isHidden = false
            
            sentMessageDate.text = message.message
            
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
