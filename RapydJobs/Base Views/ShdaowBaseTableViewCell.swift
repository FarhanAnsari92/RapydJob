//
//  ShdaowBaseTableViewCell.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 25/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class ShadowBaseView: UIView {
    
    var shouldDrawFullShadow = false
    @IBOutlet weak var rootView: UIView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        var maskRect = self.rootView.bounds.insetBy(dx: -20, dy: 0)
        if shouldDrawFullShadow {
            maskRect.origin.y -= 10
            maskRect.size.height += 25
        }
        
        let layer = self.rootView.layer
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(rect: maskRect).cgPath
        layer.mask = maskLayer
        
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
    }
}

class ShdaowBaseTableViewCell: UITableViewCell {

    var isLastCell = false
    var isFirstCell = false
    var shouldDrawFullShadow = false
    @IBOutlet weak var rootView: UIView!

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        var shadowRect = self.rootView.bounds.insetBy(dx: 0, dy: -10)
        
        if isFirstCell {
            shadowRect.origin.y += 10
        } else if isLastCell {
            shadowRect.size.height -= 10
        } else if shouldDrawFullShadow {
            shadowRect.origin.y += 10
            shadowRect.size.height -= 15
        }
        
        var maskRect = self.rootView.bounds.insetBy(dx: -20, dy: 0)
        if isFirstCell{
            maskRect.origin.y -= 10
            maskRect.size.height += 10
        } else if isLastCell {
            maskRect.size.height += 10
        } else if shouldDrawFullShadow {
            maskRect.origin.y -= 10
            maskRect.size.height += 25
        }
        
        let layer = self.rootView.layer
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.2
        layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        layer.masksToBounds = false
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(rect: maskRect).cgPath
        layer.mask = maskLayer

    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
    }

}
