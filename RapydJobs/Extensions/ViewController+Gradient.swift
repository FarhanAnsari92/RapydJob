//
//  ViewController+Gradient.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func addGradient(withRatio ratio:CGFloat = 0.5) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height * ratio)
        gradientLayer.colors = [Constants.Colors.primaryGreenColor.cgColor, Constants.Colors.primaryBlueColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//extension UITextField {
//    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        if action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.cut(_:)) || action == #selector(UIResponderStandardEditActions.delete(_:)) {
//            return false
//        } else {
//            return true
//        }
//    }
//}
