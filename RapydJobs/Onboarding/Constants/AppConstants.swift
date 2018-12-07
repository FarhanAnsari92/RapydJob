//
//  AppConstants.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 16/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit

struct AppConstants {
    
    private init () {}
    
    static let shared = AppConstants()
    
    let appTitleFont = UIFont(name: "Poppins-SemiBold", size: 30)
    let appDescFont = UIFont(name: "Poppins-Regular", size: 16)
    let buttonFont = UIFont(name: "Poppins-SemiBold", size: 16)
    let textFieldFont = UIFont(name: "Poppins-Regular", size: 18)
    
    let primaryGreenColor = UIColor(red: 119/255.0, green: 190/255.0, blue: 129/255.0, alpha: 1.0)
    let primaryBlueColor = UIColor(red: 81/255.0, green: 186/255.0, blue: 235/255.0, alpha: 1.0)
    
    let buttonBorderColor = UIColor(red: 130/255.0, green: 204/255.0, blue: 215/255.0, alpha: 1.0)
    
    let buttonGradientStart: UIColor = generateColor(withHex: "#75cbd9")!
    let buttonGradientEnd: UIColor = generateColor(withHex: "#88cdc0")!
    let errorColor: UIColor = generateColor(withHex: "#FF9300")!
    var linkedIn: UIColor = UIColor(red: 13/255.0, green: 95/255.0, blue: 164/255.0, alpha: 1.0)
    
    let clientSecret = "rB8peYmMwtNEmtLQs3QTAAorVzHthy0EHd2yja4m" // "XQ9RMClrXAs30mbwSwn5VuaQmdwl1QXCZAr5PJaY"
    
    let googleAPIKey = "AIzaSyBZA5rJQJNaRi8qq-16UaYnTB4tYTDUqiI"
    //let googleMapsAPIKey = "AIzaSyC1E0PrnYgLoP5fftpomSBQekNqGyrO7Wo"
    
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
