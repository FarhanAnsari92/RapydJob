//
//  ProfileDetailsButton.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 25/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class ProfileDetailsButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        self.contentMode = .center
        self.imageView?.contentMode = .scaleAspectFit
        self.layer.cornerRadius = self.bounds.size.height * 0.5
        self.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
