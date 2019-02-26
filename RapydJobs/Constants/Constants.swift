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
        static let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
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
    
    static func getMonthNumber(_ month: String) -> Int {
        switch month {
        case "January":
            return 1
        case "February":
            return 2
        case "March":
            return 3
        case "April":
            return 4
        case "May":
            return 5
        case "June":
            return 6
        case "July":
            return 7
        case "August":
            return 8
        case "September":
            return 9
        case "October":
            return 10
        case "November":
            return 11
        case "December":
            return 12
        default:
            return 0
        }
    }
    
    static func generateDatesArrayBetweenTwoDates(startDate: Date , endDate:Date) ->[Date] {
        var datesArray: [Date] =  [Date]()
        var startDate = startDate
        let calendar = Calendar.current
        
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        
        while startDate <= endDate {
            datesArray.append(startDate)
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
            
        }
        return datesArray
    }
    
    // get all days for a specific month
    static func getAllDates(month: Int, year: Int) -> [Date] {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        var arrDates = [Date]()
        for day in 1...numDays {
            let dateString = "\(year) \(month) \(day)"
            if let date = formatter.date(from: dateString) {
                arrDates.append(date)
            }
        }
        
        return arrDates
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
