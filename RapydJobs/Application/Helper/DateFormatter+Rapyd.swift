//
//  DateFormatter+Rapyd.swift
//  RapydJobs
//
//  Created by Maroof Khan on 27/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static let standard: DateFormatter = {
        $0.dateFormat = "mm-dd-yyyy"
        return $0
    }(DateFormatter())
    
    static func format(date: Date) -> String {
        return standard.string(from: date)
    }
    
    static func date(string: String) -> Date {
        return standard.date(from: string) ?? Date()
    }
}
