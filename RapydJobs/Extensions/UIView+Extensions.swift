//
//  UIView+Extensions.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = shadowRadius
        }
    }
    
    func embed(view: UIView, insets: UIEdgeInsets = .zero) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right)
            ])
    }
}

// Adding shadow in particular sides only
extension UIView {
    func addshadow(top: Bool, left: Bool, bottom: Bool, right: Bool, shadowRadius: CGFloat = 2.0) {
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 0.3
        
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.bounds.width
        var viewHeight = self.bounds.height
        
        if (!top) {
            y += (shadowRadius+1)
        }
        if (!bottom) {
            viewHeight -= (shadowRadius+1)
        }
        if (!left) {
            x += (shadowRadius+1)
        }
        if (!right) {
            viewWidth -= (shadowRadius+1)
        }
        
        path.move(to: CGPoint(x: x, y: y))
        
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        
        path.close()
        self.layer.shadowPath = path.cgPath
    }
}

extension String {
    private func matches(_ regex: String) -> Bool {
        let text = self.lowercased()
        print(text)
        return text.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func isValidURL() -> Bool {
        return self.matches("((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?")
    }
}

extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func toJson() -> String {
        return json
    }
}
