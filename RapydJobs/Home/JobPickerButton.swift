//
//  JobPickerButton.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 24/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class JobPickerButton: UIButton {
  
    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentMode = .center
        self.imageView?.contentMode = .scaleAspectFit
        self.layer.cornerRadius = self.bounds.size.width * 0.12
        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)

        if let imageView = imageView, let titleLabel = titleLabel {
            let padding: CGFloat = 7
            imageEdgeInsets = UIEdgeInsets(top: 5, left: titleLabel.frame.size.width+padding, bottom: 5, right: -titleLabel.frame.size.width-padding)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageView.frame.width, bottom: 0, right: imageView.frame.width)
        }
    }
}
