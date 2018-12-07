//
//  HireEmployee.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class UpdateJobOfferRequest: EndpointProvider {
    typealias Response = UpdateJobOfferResponse
    
    private let jobOfferID: String
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
        return Endpoint(api: .rapydPrivate, method: .put, path: ["api", "update-joboffer", jobOfferID], body: body)
        
    }
    
    init(jobID: String, jobSeekerID: String, contractID: String, jobOfferID:String, status: String = "start") {
        self.jobID = jobID
        self.jobSeekerID = jobSeekerID
        self.contractID = contractID
        self.status = status
        self.jobOfferID = jobOfferID
    }
    
}

struct UpdateJobOfferResponse: DTO {
    
}
