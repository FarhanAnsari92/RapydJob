//
//  CreateJob.swift
//  RapydJobs
//
//  Created by Nasir Khan on 17/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class CreateJobRequest: EndpointProvider {
    typealias Response = CreateJobResponse
    
    private let title: String
    private let description: String
    private let min_salary: String
    private let max_salary: String
    private let job_type: String
    private let contract_length: String
    private let related_fields: Array<String>
    
    private let dates: Array<Hours>?
    
    var endpoint: Endpoint {
        
        let dateDict = [ "day"          : "Monday",
                         "start_time"   : "09:00",
                         "end_time"     : "05:00" ]
        
        let dictionary = [ "title"              : title,
                           "description"        : description,
                           "min_salary"         : min_salary,
                           "max_salary"         : max_salary,
                           "job_type"           : job_type,
                           "contract_length"    : contract_length,
                           "related_fields"     : related_fields,
                           "dates"              : [dateDict] ] as [String : Any]
        
        let body = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "store-job"], body: body)
        
    }
    
    init(title: String, description: String, min_salary: String, max_salary: String, job_type: String, contract_length: String, related_fields: Array<String>, dates: Array<Hours>?) {
        self.title = title
        self.description = description
        self.min_salary = min_salary
        self.max_salary = max_salary
        self.job_type = job_type
        self.contract_length = contract_length
        self.related_fields = related_fields
        
        if let getDates = dates {
            self.dates = getDates
        } else {
            self.dates = []
        }
    }    
}

struct CreateJobResponse: DTO {
    let title: String
    let description: String
    let min_salary: String
    let max_salary: String
    let job_type: String
    let contract_length: String
    let id: Int
    let jobs_relateedfield: [RelatedField]
    
    struct RelatedField: DTO {
        let related_field: String
    }
}

struct Hours {
    let day: String
    let start: String
    let End: String
}
