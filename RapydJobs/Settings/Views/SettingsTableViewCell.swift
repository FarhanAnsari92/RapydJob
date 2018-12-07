//
//  SettingsTableViewCell.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 01/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.actionButton.tintColor = UIColor.lightGray
        self.actionButton.contentMode = .center
        self.actionButton.imageView?.contentMode = .scaleAspectFit
        let insets: CGFloat = 7
        self.actionButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
    }
    
    func populateWithRowModel(_ model:SettingRowModel) {
        self.titleLabel.text = model.title
        switch model.type {
        case .normal:
            self.actionButton.isHidden = true
        case .disclose:
            self.actionButton.setImage(UIImage(named: "ic_next"), for: .normal)
        case .edit:
            self.actionButton.setImage(UIImage(named: "ic_edit"), for: .normal)
        case .alert:
            self.actionButton.isHidden = true
            self.titleLabel.textColor = UIColor.red
        case .notification:
            self.actionButton.isHidden = true
            let notificationSwitch = UISwitch()
            notificationSwitch.onTintColor = Constants.Colors.primaryBlueColor
            self.accessoryView = notificationSwitch
        }
    }
}
