//
//  EmptyPlaceholderView.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 2/10/19.
//  Copyright © 2019 chymps. All rights reserved.
//

import UIKit

class EmptyPlaceholderView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var message: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("EmptyPlaceholderView", owner: self, options: nil)
        addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth ]
    }

}
