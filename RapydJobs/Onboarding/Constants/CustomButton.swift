//
//  CustomButton.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 23/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGradient()
    }
    
    private func addGradient() {
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.startPoint = .zero
        gradient.endPoint = .init(x: 1.0, y: 1.0)
        gradient.colors = [AppConstants.shared.buttonGradientStart.cgColor, AppConstants.shared.buttonGradientEnd.cgColor]
        
        layer.addSublayer(gradient)
    }
}
