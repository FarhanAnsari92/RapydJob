//
//  Storyboards.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 23/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import Foundation

enum Storyboards: String {
    
    case Login
    case EmployerSignup
    case JobseekerSignup
    case Home
    case SideMenu
    case Settings
    case HRVC
    case ActiveJobs
    
    func name() -> String {
        return self.rawValue
    }
}
