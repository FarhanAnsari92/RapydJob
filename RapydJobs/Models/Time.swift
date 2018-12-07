//
//  Time.swift
//  RapydJobs
//
//  Created by Maroof Khan on 15/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

struct Time {
    
    static let defaultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter
    }()
    
    let start: Date
    let end: Date?
    let formatter: DateFormatter
    
    var string: String {
        let start = formatter.string(from: self.start)
        if let end = end {
            return "\(start) to \(formatter.string(from: end))"
        } else {
            return start
        }
    }
}
