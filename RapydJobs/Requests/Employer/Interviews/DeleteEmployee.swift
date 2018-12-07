//
//  HireEmployee.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class DeleteEmployeeRequest: EndpointProvider {
    typealias Response = DeleteEmployeeResponse
    
    
    private let jobSeekerID: String
    
    var endpoint: Endpoint {
        
        return Endpoint(api: .rapydPrivate, method: .delete, path: ["api", "delete-hireemployee", jobSeekerID], body: nil)
        
    }
    
    init(jobSeekerID: String) {
        self.jobSeekerID = jobSeekerID
    }
    
}

struct DeleteEmployeeResponse: DTO {
    
}
