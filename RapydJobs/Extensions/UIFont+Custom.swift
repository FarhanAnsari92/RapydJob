//
//  UIFont+Custom.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 28/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit

enum FontStyle {
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case black
}

extension UIFont {
    
    static func getDefaultFont(withSize size:CGFloat = 14) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func getDefaultFont(withSize size:CGFloat = 14, andStyle style:FontStyle) -> UIFont {
        
        var fontName = "Poppins-Regular"
        switch style {
        case .thin:
            fontName = "Poppins-Thin"
        case .light:
            fontName = "Poppins-Light"
        case .regular:
            fontName = "Poppins-Regular"
        case .medium:
            fontName = "Poppins-Medium"
        case .semibold:
            fontName = "Poppins-SemiBold"
        case .bold:
            fontName = "Poppins-Bold"
        case .black:
            fontName = "Poppins-Black"
        }
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }

}
