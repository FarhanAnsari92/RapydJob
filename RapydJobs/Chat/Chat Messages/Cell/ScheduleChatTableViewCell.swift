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
    
    func populateData(message: Message) {
        
        let userId = AppContainer.shared.user.user?.userId
        
        if Int(message.senderId) != userId {
            
            receivedBubbleView.isHidden = false
            receivedMessageDate.isHidden = false
            
            sentBubbleView.isHidden = true
            sentMessageDate.isHidden = true
            
            receivedMessageDate.text = message.message
            
        } else {
            
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
