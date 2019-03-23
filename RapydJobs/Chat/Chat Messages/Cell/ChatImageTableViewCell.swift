//
//  ChatImageTableViewCell.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/6/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class ChatImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var senderImage: UIImageView!
    @IBOutlet weak var senderImageParent: UIView!
    @IBOutlet weak var senderProfileImage: UIImageView!
    @IBOutlet weak var sentImage: UIImageView!
    @IBOutlet weak var sentImageParent: UIView!
//    @IBOutlet weak var time: UILabel!
    var imageHandler: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.senderImage.layer.cornerRadius = self.senderImage.frame.height / 2
        self.senderImageParent.layer.cornerRadius = 15
        self.senderImage.layer.cornerRadius = 15
        self.senderImage.clipsToBounds = true
        
        self.sentImageParent.layer.cornerRadius = 15
        self.sentImage.layer.cornerRadius = 15
        self.sentImage.clipsToBounds = true
        
        self.senderProfileImage.layer.cornerRadius = 15
        self.senderProfileImage.clipsToBounds = true
        
        let senderImageGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapAtImage(_:)))
        self.senderImage.isUserInteractionEnabled = true
        self.senderImage.addGestureRecognizer(senderImageGesture)
        let sentImageGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapAtImage(_:)))
        self.sentImage.isUserInteractionEnabled = true
        self.sentImage.addGestureRecognizer(sentImageGesture)
        
    }
    
    @objc func tapAtImage(_ sender: UITapGestureRecognizer) {
        self.imageHandler?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(message: Message) {
        
        let userId = AppContainer.shared.user.user?.userId
        
        if Int(message.senderId) != userId {
            
            self.senderImage.isHidden = false
            self.senderImageParent.isHidden = false
            self.senderProfileImage.isHidden = false
            self.senderImage.setChatImageWithName(message.message) //setImageWithName(message.message)
            self.sentImage.isHidden = true
            self.sentImageParent.isHidden = true
            
        } else {
            
            self.senderImage.isHidden = true
            self.senderImageParent.isHidden = true
            self.senderProfileImage.isHidden = true
            self.sentImage.isHidden = false
            self.sentImageParent.isHidden = false
            self.sentImage.setChatImageWithName(message.message)
            
        }
    }
    
}
