//
//  HireEmployee.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class UpdateEmployeeRequest: EndpointProvider {
    typealias Response = UpdateEmployeeResponse
    
    private let jobID: String
    private let jobSeekerID: String
    private let status: String
    
    var endpoint: Endpoint {
        
        let dictionary = [
            "job_id":jobID,
            "status":status
        ]
        
        
        
        let body = try? JSONSerialization.data( withJSONObject: dictionary, options: [])
        
        return Endpoint(api: .rapydPrivate, method: .put, path: ["api", "update-hireemployee", jobSeekerID], body: body)
        
    }
    
    init(jobID: String, jobSeekerID: String, status: String = "complete") {
        self.jobID = jobID
        self.jobSeekerID = jobSeekerID
        self.status = status
    }
    
}

struct UpdateEmployeeResponse: DTO {
    
}
