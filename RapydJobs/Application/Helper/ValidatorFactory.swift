//
//  ValidatorFactory.swift
//  RapydJobs
//
//  Created by Maroof Khan on 23/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import Validator

struct ValidatorFactory {
    
    enum ValidationError: Error {
        case eh
    }
    
    static let doubleHay: (String) -> Bool = { _ in
        return true
    }
    
    static let username: (String) -> Bool = { _ in
        return true
    }
    
    static let email: (String) -> Bool = {
        let rule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationError.eh)
        switch $0.validate(rule: rule) {
        case .invalid: return false
        case .valid: return true
        }
    }
}
