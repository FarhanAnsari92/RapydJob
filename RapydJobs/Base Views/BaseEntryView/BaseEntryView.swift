//
//  BaseEntryView.swift
//  RapydJobs
//
//  Created by Maroof Khan on 20/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class BaseEntryView: UIView {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet var constraint: NSLayoutConstraint!
    
    convenience init() {
        self.init(frame: .zero)
        embed(view: loadNib()!)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        embed(view: loadNib()!)
        setup()
    }
    
    private func loadNib() -> UIView? {
        return Bundle.main.loadNibNamed("BaseEntryView", owner: self, options: nil)?.first as? UIView
    }
    
    private func setup() {
        title.font = .systemFont(ofSize: 22.0)
        title.textColor = Constants.Colors.primaryBlueColor
        
        place.font = .systemFont(ofSize: 18.0)
        place.textColor = .lightGray
        
        time.font = .systemFont(ofSize: 18.0)
        time.textColor = .lightGray
    }
    
    func setup(title: String, place: String, time: String, expand: @escaping () -> Void) {
        self.title.text = title
        self.place.text = place
        self.time.text = time
        self.expandClosure = expand
    }
    
    var expandClosure: (() -> Void)? = nil
    func expandCell() -> Void {
        constraint.isActive = !constraint.isActive
    }
    
    @IBAction func expand() {
        expandClosure?()
    }
}

