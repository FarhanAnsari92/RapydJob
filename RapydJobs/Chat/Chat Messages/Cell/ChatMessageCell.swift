//
//  ChatMessageCell.swift
//  RapydJobs
//
//  Created by MuhammadKhan on 8/26/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class ChatMessageCell: UITableViewCell {

    let receivedMessageTV: UITextView = {
        let tv = UITextView()
        tv.text = ""
        tv.font = .systemFont(ofSize: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .black
        tv.isEditable = false
        tv.isSelectable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    let receivedBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let sentBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.5333333333, green: 0.7803921569, blue: 0.5764705882, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let sentMessageTV: UITextView = {
        let tv = UITextView()
        tv.text = ""
        tv.font = .systemFont(ofSize: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        tv.isEditable = false
        tv.isSelectable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let receivedMessageDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = .black // #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = ""
        return label
    }()
    
    let sentMessageDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .right
        label.textColor = .white
        label.text = ""
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        receivedMessageDate.text?.removeAll()
        receivedMessageTV.text.removeAll()
        //profileImage.image = nil
    }
    
    private func setupViews() {
        
        self.selectionStyle = .none
        
        addSubview(profileImage)
        profileImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        
        addSubview(receivedMessageDate)
        receivedMessageDate.heightAnchor.constraint(equalToConstant: 15).isActive = true
        receivedMessageDate.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 58).isActive = true
        receivedMessageDate.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        addSubview(sentMessageDate)
        sentMessageDate.heightAnchor.constraint(equalToConstant: 15).isActive = true
        sentMessageDate.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        sentMessageDate.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        addSubview(receivedBubbleView)
        receivedBubbleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        receivedBubbleView.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8).isActive = true
        receivedBubbleView.bottomAnchor.constraint(equalTo: receivedMessageDate.topAnchor, constant: -4).isActive = true
        receivedBubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: self.bounds.size.width - 50).isActive = true
        receivedBubbleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 32).isActive = true
        
        receivedBubbleView.addSubview(receivedMessageTV)
        receivedMessageTV.topAnchor.constraint(equalTo: receivedBubbleView.topAnchor, constant: 5).isActive = true
        receivedMessageTV.leadingAnchor.constraint(equalTo: receivedBubbleView.leadingAnchor, constant: 10).isActive = true
        receivedMessageTV.trailingAnchor.constraint(equalTo: receivedBubbleView.trailingAnchor, constant: -10).isActive = true
        receivedMessageTV.bottomAnchor.constraint(equalTo: receivedBubbleView.bottomAnchor, constant: -5).isActive = true
        
        addSubview(sentBubbleView)
        sentBubbleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        sentBubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        sentBubbleView.bottomAnchor.constraint(equalTo: receivedMessageDate.topAnchor, constant: -4).isActive = true
        sentBubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: self.bounds.size.width - 50).isActive = true
        sentBubbleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 32).isActive = true
        
        sentBubbleView.addSubview(sentMessageTV)
        sentMessageTV.topAnchor.constraint(equalTo: sentBubbleView.topAnchor, constant: 5).isActive = true
        sentMessageTV.leadingAnchor.constraint(equalTo: sentBubbleView.leadingAnchor, constant: 10).isActive = true
        sentMessageTV.trailingAnchor.constraint(equalTo: sentBubbleView.trailingAnchor, constant: -10).isActive = true
        sentMessageTV.bottomAnchor.constraint(equalTo: sentBubbleView.bottomAnchor, constant: -5).isActive = true
    }
    
    func populate(message: Message) {
        
        let userId = AppContainer.shared.user.user?.userId
        
        if Int(message.senderId) != userId {
            
            receivedBubbleView.isHidden = false
            receivedMessageTV.isHidden = false
            profileImage.isHidden = false
            receivedMessageDate.isHidden = false
            
            sentBubbleView.isHidden = true
            sentMessageTV.isHidden = true
            sentMessageDate.isHidden = true
            
            receivedMessageTV.text = message.message
            receivedMessageDate.text = message.createdAt
            //profileImage.image = message.userImage.image
            
        } else {
            
            receivedBubbleView.isHidden = true
            receivedMessageTV.isHidden = true
            profileImage.isHidden = true
            receivedMessageDate.isHidden = true
            
            sentBubbleView.isHidden = false
            sentMessageTV.isHidden = false
            sentMessageDate.isHidden = false
            
            sentMessageTV.text = message.message
            sentMessageDate.text = message.createdAt
        }
    }
}
