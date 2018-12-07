//
//  CreateJob.swift
//  RapydJobs
//
//  Created by Nasir Khan on 17/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class DeleteJobRequest: EndpointProvider {
    typealias Response = DeleteJobResponse
    
    private let jobID: String
    
    var endpoint: Endpoint {
        
        return Endpoint(api: .rapydPrivate, method: .delete, path: ["api", "delete-job", jobID], body: nil)
        
    }
    
    init(jobID: String) {
        self.jobID = jobID
    }
    
}

struct DeleteJobResponse: DTO {
    
}
