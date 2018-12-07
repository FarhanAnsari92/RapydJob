//
//  HireEmployee.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class HireEmployeeRequest: EndpointProvider {
    typealias Response = HireEmployeeResponse
    
    private let jobID: String
    private let jobSeekerID: String
    private let status: String
    
    var endpoint: Endpoint {
        
        let dictionary = [
            "job_id":jobID,
            "jobseeker_id":jobSeekerID,
            "status":status
        ]
        
        
        
        let body = try? JSONSerialization.data( withJSONObject: dictionary, options: [])
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "store-hireemployee"], body: body)
        
    }
    
    init(jobID: String, jobSeekerID: String, status: String = "start") {
        self.jobID = jobID
        self.jobSeekerID = jobSeekerID
        self.status = status
    }
    
}

struct HireEmployeeResponse: DTO {
    
}
