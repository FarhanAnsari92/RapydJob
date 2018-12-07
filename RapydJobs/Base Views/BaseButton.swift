//
//  BaseButton.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class BaseButton: UIButton {
    
    var gradientLayer: CAGradientLayer?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addGradient()
        shape()
        
    }
    
    private enum Constant {
        static let font = Constants.Fonts.button
    }
    
    func setup(title: String) {
        
        contentEdgeInsets.left = 25.0
        contentEdgeInsets.right = 25.0
        
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = Constant.font
    }
    
    private func shape() {
        layer.masksToBounds = true
        layer.cornerRadius = bounds.midY
    }
    
    private func addGradient() {
        
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.startPoint = .zero
        gradient.endPoint = .init(x: 1.0, y: 1.0)
        gradient.colors = [Constants.Colors.buttonGradientStart.cgColor, Constants.Colors.buttonGradientEnd.cgColor]
            
        layer.insertSublayer(gradient, at: 0)
        
        gradientLayer = gradient
        
    }

}
