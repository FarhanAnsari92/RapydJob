//
//  Constants.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit

class Constants: NSObject {
    
    public struct linkedin {
        static let clientID = "86gmqwtl9kgi1z"
        static let clientSecret = "PZEKSNaZhlzhF3u3"
        static let applicationId = "22939066"
    }

    public struct Colors {
        
        static let primaryGreenColor = UIColor(red: 119/255.0, green: 190/255.0, blue: 129/255.0, alpha: 1.0)
        static let primaryBlueColor = UIColor(red: 81/255.0, green: 186/255.0, blue: 235/255.0, alpha: 1.0)
        
        static let buttonBorderColor = UIColor(red: 130/255.0, green: 204/255.0, blue: 215/255.0, alpha: 1.0)
        
        static let buttonGradientStart: UIColor = generateColor(withHex: "#75cbd9")!
        static let buttonGradientEnd: UIColor = generateColor(withHex: "#88cdc0")!
        static var linkedIn: UIColor = UIColor(red: 13/255.0, green: 95/255.0, blue: 164/255.0, alpha: 1.0)
        
        private static func generateColor(withHex hex: String) -> UIColor? {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
            
            var rgb: UInt32 = 0
            
            var r: CGFloat = 0.0
            var g: CGFloat = 0.0
            var b: CGFloat = 0.0
            var a: CGFloat = 1.0
            
            let length = hexSanitized.count
            
            guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
            
            if length == 6 {
                r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
                g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
                b = CGFloat(rgb & 0x0000FF) / 255.0
                
            } else if length == 8 {
                r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
                g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
                b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
                a = CGFloat(rgb & 0x000000FF) / 255.0
                
            } else {
                return nil
            }
            return .init(red: r, green: g, blue: b, alpha: a)
        }
    }
    
    public struct Fonts {
        static let fieldTitle: UIFont = .systemFont(ofSize: 16.0)
        static let fieldTextField: UIFont = .systemFont(ofSize: 20.0)
        static let button: UIFont = .systemFont(ofSize: 16.0, weight: .semibold)
    }
}

let displayStyle: (UIImageView) -> Void = { imageView in
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = imageView.bounds.midY
    imageView.layer.borderWidth = 1.0
    imageView.layer.borderColor = UIColor.lightGray.cgColor
}

let actionStyle: (UIButton, UIImage) -> Void = { button, image in
    button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
    button.imageEdgeInsets = .init(top: 3, left: -10, bottom: 3, right: 3)
    button.contentHorizontalAlignment = .left
    button.imageView?.contentMode = .scaleAspectFit
    
    button.titleLabel?.font = .systemFont(ofSize: 12.0)
    button.setTitleColor(.lightGray, for: .normal)
}

let titleStyle: (UILabel) -> Void = { label in
    label.font = .systemFont(ofSize: 20.0)
    label.textColor = .black
}

let timeStyle: (UILabel) -> Void = { label in
    label.font = .systemFont(ofSize: 12.0)
    label.textColor = .lightGray
}

let jobTitleStyle: (UILabel) -> Void = { label in
    label.font = .systemFont(ofSize: 14.0)
    label.textColor = .lightGray
}
