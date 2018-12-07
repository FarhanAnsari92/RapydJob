//
//  EmployerJobsDropdownRequest.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 28/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

final class EmployerJobsDropdownRequest: EndpointProvider {
    
    typealias Response = [EmployerJobsDropdownResponse]
    
    var endpoint: Endpoint {
        return Endpoint(api: .rapydPrivate, method: .get, path: ["api", "organization-dropdown-jobs"], body: nil)
    }
}

struct EmployerJobsDropdownResponse: DTO {
    let id: Int
    let title: String
}
