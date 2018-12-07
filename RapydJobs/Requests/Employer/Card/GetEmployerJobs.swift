//
//  GetEmployerJobs.swift
//  RapydJobs
//
//  Created by Nasir Khan on 12/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation


class GetEmployerJobsRequest: EndpointProvider {
    typealias Response = GetEmployerJobsResponse
    
    private let numberOfJobs: String
    
    var endpoint: Endpoint {
        
        return Endpoint(api: .rapydPrivate, method: .get, path: ["api", "organization-jobs", numberOfJobs, "active"], body: nil)
        
    }
    
    init(numberOfJobs: String) {
        self.numberOfJobs = numberOfJobs
    }
    
}

struct GetEmployerJobsResponse: DTO {
    
//    let jobs : Array<Job>
    
}


