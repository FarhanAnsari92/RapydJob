//
//  JobsDropDownItem.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 28/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit

class JobsDropDownItem {
    
    init(dto: EmployerJobsDropdownResponse) {
        self.identifier = dto.id
        self.title = dto.title
    }
    
    var identifier: Int
    var title: String

    init(_ identifier:Int, _ title:String) {
        self.identifier = identifier
        self.title = title
    }
}
