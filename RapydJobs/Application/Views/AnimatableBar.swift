//
//  AnimatableBar.swift
//  RapydJobs
//
//  Created by Maroof Khan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class AnimatableBar: UIView {
    
    private lazy var animatableLayer: CAShapeLayer = {
        $0.path = UIBezierPath(rect: bounds).cgPath
        $0.fillColor = UIColor.clear.cgColor
        layer.addSublayer($0)
        return $0
    }(CAShapeLayer())
    
    private lazy var animation: CABasicAnimation = {
        $0.fromValue = 0.0
        $0.toValue = 1.0
        $0.duration = 0.3
        $0.fillMode = kCAFillModeForwards
        $0.isRemovedOnCompletion = false
        return $0
    }(CABasicAnimation(keyPath: "strokeEnd"))
    
    private lazy var deanimation: CABasicAnimation = {
        $0.fromValue = 1.0
        $0.toValue = 0.0
        $0.duration = 0.3
        $0.fillMode = kCAFillModeForwards
        $0.isRemovedOnCompletion = false
        return $0
    }(CABasicAnimation(keyPath: "strokeEnd"))
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func animate(with color: UIColor = Constants.Colors.buttonGradientStart) {
        animatableLayer.strokeColor = color.cgColor
        layer.add(animation, forKey: "addition")
    }
    
    func deanimate() {
        animatableLayer.add(deanimation, forKey: "removal")
    }
}
