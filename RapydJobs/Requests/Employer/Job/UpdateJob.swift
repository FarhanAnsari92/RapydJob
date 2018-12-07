//
//  CreateJob.swift
//  RapydJobs
//
//  Created by Nasir Khan on 17/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class UpdateJobRequest: EndpointProvider {
    typealias Response = UpdateJobResponse
    
    private let jobID: String
    
    private let title: String
    private let description: String
    private let min_salary: String
    private let max_salary: String
    private let job_type: String
    private let contract_length: String
    
    private let dates: Array<Hours>?
    
    var endpoint: Endpoint {
        
        let dictionary = [
            
            "title":title,
            "description":description,
            "min_salary":min_salary,
            "max_salary":max_salary,
            "job_type":job_type,
            "contract_length":contract_length,
            "dates": dates as Any
            ] as [String : Any]
        
        let body = try? JSONSerialization.data( withJSONObject: dictionary, options: [])
        
        return Endpoint(api: .rapydPrivate, method: .put, path: ["api", "update-job", jobID], body: body)
        
    }
    
    init(title: String, description: String, min_salary: String, max_salary: String, job_type: String, contract_length: String, related_fields: Array<String>, dates: Array<Hours>?, jobID: String) {
        self.title = title
        self.description = description
        self.min_salary = min_salary
        self.max_salary = max_salary
        self.job_type = job_type
        self.contract_length = contract_length
        
        if let getDates = dates {
            self.dates = getDates
        } else {
            self.dates = []
        }
        
        self.jobID = jobID
        
    }
    
}

struct UpdateJobResponse: DTO {
    
}
