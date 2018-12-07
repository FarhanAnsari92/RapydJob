//
//  GradientButton.swift
//  RapydJobs
//
//  Created by Maroof Khan on 24/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class GradientButton: UIButton {
    var gradientLayer: CAGradientLayer?
    
    func applyGradient(colors: [UIColor], start: CGPoint, end: CGPoint) {
        
        if let gradient = gradientLayer {
            gradient.removeFromSuperlayer()
            gradientLayer = nil
        }
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.startPoint = .zero
        gradient.endPoint = .init(x: 1.0, y: 1.0)
        gradient.colors = [Constants.Colors.buttonGradientStart.cgColor, Constants.Colors.buttonGradientEnd.cgColor]
        
        gradientLayer = gradient
    }
}
