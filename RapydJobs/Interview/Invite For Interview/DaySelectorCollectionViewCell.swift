//
//  DaySelectorCollectionViewCell.swift
//  RapydJobs
//
//  Created by Maroof Khan on 27/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class DaySelectorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var weekday: UILabel!
    @IBOutlet weak var day: UILabel!
    
    private var gradientLayer: CAGradientLayer?
    
    override var isSelected: Bool {
        didSet {
            // add/remove gradient layer to background
            toggle(selected: isSelected)
        }
    }
    
    private var viewModel: DaySelectorCellViewModel! {
        didSet { update() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        unselect()
    }
    
    func setup(with viewModel: DaySelectorCellViewModel) {
        self.viewModel = viewModel
    }
    
    private func update() {
        weekday.text = viewModel.weekday
        day.text = viewModel.day
    }
    
    private func toggle(selected: Bool) {
        gradientLayer?.removeFromSuperlayer()
        
        if selected {
            let gradient = CAGradientLayer()
            gradient.frame = bounds
            gradient.startPoint = .zero
            gradient.endPoint = .init(x: 1.0, y: 1.0)
            gradient.colors = [Constants.Colors.buttonGradientStart.cgColor, Constants.Colors.buttonGradientEnd.cgColor]
            
            layer.insertSublayer(gradient, at: 0)
            gradientLayer = gradient
            
            weekday.textColor = .white
            day.textColor = .white
        } else {
            unselect()
        }
    }
    
    private func unselect() {
        weekday.textColor = .lightGray
        day.textColor = .lightGray
    }
}
