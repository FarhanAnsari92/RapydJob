//
//  CardButton.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 24/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class CardButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentMode = .center
        self.imageView?.contentMode = .scaleAspectFit
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = self.bounds.midX
        let insets = self.bounds.size.width * 0.28
        self.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)

        self.layer.masksToBounds = false
        self.layer.shadowRadius = 6
        self.layer.shadowColor = Constants.Colors.primaryBlueColor.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = .zero

    }
}
