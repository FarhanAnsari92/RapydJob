//
//  SwipeShortlistEmployer.swift
//  RapydJobs
//
//  Created by Nasir Khan on 13/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class SwipeShortlistJobSeekerRequest: EndpointProvider {
    typealias Response = SwipeShortlistJobSeekerResponse
    
    private let jobID: String
    
    var endpoint: Endpoint {
        
        let body = try? [
            "job_id":jobID
            ].toJSONData()
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "store-shortlist-jobs"], body: body)
        
    }
    
    init(jobID: String) {
        self.jobID = jobID
    }
    
}

struct SwipeShortlistJobSeekerResponse: DTO {
    
}
