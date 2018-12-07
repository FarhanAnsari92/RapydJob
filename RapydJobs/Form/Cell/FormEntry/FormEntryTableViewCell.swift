//
//  FormEntryTableViewCell.swift
//  RapydJobs
//
//  Created by Maroof Khan on 20/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class FormEntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet var constraint: NSLayoutConstraint!
    @IBOutlet weak var expandButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup(title: String, place: String, time: String) {
        self.title.text = title
        self.place.text = place
        self.time.text = time
    }
    
    private func setup() {
        title.font = .systemFont(ofSize: 22.0)
        title.textColor = Constants.Colors.primaryBlueColor
        
        place.font = .systemFont(ofSize: 18.0)
        place.textColor = .lightGray
        
        time.font = .systemFont(ofSize: 18.0)
        time.textColor = .lightGray
    }
    
    var callback: (() -> Void)?
    
    func setup(with vm: FormEntryViewModel, callback: @escaping () -> Void) {
        self.callback = callback
        setup(title: vm.title, place: vm.place, time: vm.time)
        vm.expanded ? (constraint.constant = 24.0) : (constraint.constant = 0.0)
    }
    
    @IBAction func expand() {
        callback?()
    }

}
