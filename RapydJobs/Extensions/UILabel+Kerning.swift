//
//  UILabel+Kerning.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 28/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    @IBInspectable var kerning: Float {
        get {
            var range = NSRange(location: 0, length: (text ?? "").count)
            guard let kern = attributedText?.attribute(.kern, at: 0, effectiveRange: &range),
                let value = kern as? NSNumber
                else {
                    return 0
            }
            return value.floatValue
        }
        set {
            var attText:NSMutableAttributedString
            
            if let attributedText = attributedText {
                attText = NSMutableAttributedString(attributedString: attributedText)
            } else if let text = text {
                attText = NSMutableAttributedString(string: text)
            } else {
                attText = NSMutableAttributedString(string: "")
            }
            
            let range = NSRange(location: 0, length: attText.length)
            attText.addAttribute(.kern, value: NSNumber(value: newValue), range: range)
            self.attributedText = attText
        }
    }
}
