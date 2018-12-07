//
//  BaseDropdownButton.swift
//  RapydJobs
//
//  Created by Maroof Khan on 15/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

protocol BaseDropdownButtonDelegate {
    func didTap(_ button: BaseDropdownButton)
}

class BaseDropdownButton: ShadowBaseView {
    @IBOutlet weak var titleLabel: UILabel!
    var delegate: BaseDropdownButtonDelegate?
    var completion: (() -> Void)?
    
    convenience init() {
        self.init(frame: .zero)
        embed(view: loadNib()!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        embed(view: loadNib()!)
    }
    
    private func loadNib() -> UIView? {
        return Bundle.main.loadNibNamed("BaseDropdownButton", owner: self, options: nil)?.first as? UIView
    }
    
    override func layoutSubviews() {
        rootView.layer.cornerRadius = rootView.layer.bounds.midY
        shouldDrawFullShadow = true
        setNeedsDisplay()
    }
    
    func setup(title: String) {
        titleLabel.text = title
    }
    
    @IBAction func tapped() {
        completion?()
    }
}
