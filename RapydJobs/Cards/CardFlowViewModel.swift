//
//  CardFlowViewModel.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 29/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit
class CardFlowViewModel: NSObject {

    var flow: CardFlow
    let accountType = AppContainer.shared.user.user?.accountType ?? "" // AppContainer.shared.user.accountType
    
    init(withFlow flow:CardFlow) {
        self.flow = flow
    }
    
    func title() -> String {
        
        switch flow {
        case .dashboard:
            switch accountType {
            case "organization":
                return "Employer Dashboard"
            case "jobseeker":
                return "Jobseeker Dashboard"
            default:
                return ""
            }
        case .shortlisted:
            return "Shortlisted"
        }
    }
    
}

