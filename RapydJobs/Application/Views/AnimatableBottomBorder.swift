//
//  AnimatableBottomBorder.swift
//  RapydJobs
//
//  Created by Maroof Khan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class AnimatableBottomBorder: UIView {

    private var border: UIView!
    private var animatableLayer: CAShapeLayer?
    
    convenience init(embedIn view: UIView, height: CGFloat = 1.0, color: UIColor = .lightGray) {
        self.init(frame: .zero)
        embed(in: view, with: height, of: color)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Also, who implements that?!")
    }
    
    func animate(with color: UIColor = Constants.Colors.buttonGradientStart) {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(rect: border.bounds).cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color.cgColor
        
        border.layer.addSublayer(layer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.3
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        
        layer.add(animation, forKey: "addition")
        
        animatableLayer = layer
    }
    
    func deanimate() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = 0.3
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        
        animatableLayer?.add(animation, forKey: "removal")
    }
    
    func colorIt(with color: UIColor = Constants.Colors.buttonGradientStart) {
        animatableLayer?.strokeColor = color.cgColor
    }
    
    private func embed(in view: UIView, with height: CGFloat, of color: UIColor) {
        border = UIView(frame: .zero)
        border.backgroundColor = color
        
        embed(border: border, in: view, height: height)
    }
    
    private func embed(border: UIView, in view: UIView, height: CGFloat) {
        border.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(border)
        NSLayoutConstraint.activate([
            border.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            border.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
            border.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            border.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}
