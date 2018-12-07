//
//  HireEmployee.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class OfferTheJobRequest: EndpointProvider {
    typealias Response = OfferTheJobResponse
    
    private let jobID: String
    private let jobSeekerID: String
    private let contractID: String
    private let status: String
    
    var endpoint: Endpoint {
        
        let dictionary = [
            "job_id":jobID,
            "jobseeker_id":jobSeekerID,
            "contract_id":contractID,
            "status":status
        ]
        
        let body = try? JSONSerialization.data( withJSONObject: dictionary, options: [])
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "store-joboffer"], body: body)
        
    }
    
    init(jobID: String, jobSeekerID: String, contractID: String, status: String = "pending") {
        self.jobID = jobID
        self.jobSeekerID = jobSeekerID
        self.contractID = contractID
        self.status = status
    }
    
}

struct OfferTheJobResponse: DTO {
    
}
