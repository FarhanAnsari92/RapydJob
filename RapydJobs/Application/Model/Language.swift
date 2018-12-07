//
//  Language.swift
//  RapydJobs
//
//  Created by Maroof Khan on 27/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

struct Language {
    
    enum Expertise: String {
        case novice
        case intermediate
        case expert
    }
    
    let title: String
    let expertise: Expertise
}
