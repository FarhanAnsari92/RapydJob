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

        self.semanticContentAttribute = .forceRightToLeft

        titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
    }
}
