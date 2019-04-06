//
//  ChatListCell.swift
//  RapydJobs
//
//  Created by MuhammadKhan on 8/26/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {

    let cardView: UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
        cv.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0.1176470588, alpha: 1)
        cv.layer.shadowRadius = 4
        cv.layer.shadowOpacity = 0.3
        cv.layer.shadowOffset = CGSize(width: -2, height: 0.5)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let mainStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let innerStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 5
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let titleStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 5
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let userImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 25
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = #imageLiteral(resourceName: "Placeholder")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0.1176470588, alpha: 1)
        label.text = ""
        return label
    }()
    
    let userMessage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.text = ""
        return label
    }()
    
    let messageDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .right
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
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
        
        userName.text?.removeAll()
        userMessage.text?.removeAll()
        messageDate.text?.removeAll()
        userImage.image = #imageLiteral(resourceName: "Placeholder")
    }
    
    private func setupViews() {
        
        self.selectionStyle = .none
        
        addSubview(cardView)
        cardView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        cardView.addSubview(mainStackView)
        mainStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16).isActive = true
        
        userImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        mainStackView.addArrangedSubview(userImage)
        
        titleStackView.addArrangedSubview(userName)
        titleStackView.addArrangedSubview(messageDate)
        
        innerStackView.addArrangedSubview(titleStackView)
        innerStackView.addArrangedSubview(userMessage)
        
        mainStackView.addArrangedSubview(innerStackView)
    }
    
    func populate(chat: ChatList) {
        
        messageDate.text = chat.createdAt
        //userName.text = chat.name.capitalized
        guard let userId = AppContainer.shared.user.user?.userId else {
            return
        }
        let users = chat.users.filter({ $0.id != userId })
        
        if chat.messages.count > 0 {
            if chat.messages.last?.type == "file" {
                userMessage.text = "Attachment"
            } else {
                userMessage.text = chat.messages.last?.message
            }
            
        } else {
            userMessage.text = "No messages available to view"
        }
        if users.count > 0 {
            guard let imageUrl = users.first?.profileImage,
            let name = users.first?.username else {
                return
            }
            userName.text = name
            userImage.setImageWithName(imageUrl)
        }
    }
}
