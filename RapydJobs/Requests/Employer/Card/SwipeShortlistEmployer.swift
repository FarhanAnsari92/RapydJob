//
//  SwipeShortlistEmployer.swift
//  RapydJobs
//
//  Created by Nasir Khan on 13/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class SwipeShortlistEmployerRequest: EndpointProvider {
    typealias Response = SwipeShortlistEmployerResponse
    
    private let userID: String
    private let jobID: String
    
    var endpoint: Endpoint {
        
        let body = try? [
            "user_id":userID,
            "job_id":jobID
            ].toJSONData()
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "store-shortlist-jobseekers"], body: body)
        
    }
    
    init(userID: String, jobID: String) {
        self.userID = userID
        self.jobID = jobID
    }
    
}

struct SwipeShortlistEmployerResponse: DTO {
    
}
