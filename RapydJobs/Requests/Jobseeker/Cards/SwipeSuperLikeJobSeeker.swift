//
//  SwipeSuperLikeEmployer.swift
//  RapydJobs
//
//  Created by Nasir Khan on 13/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class SwipeSuperLikeJobSeekerRequest: EndpointProvider {
    typealias Response = SwipeSuperLikeJobSeekerResponse
    
    private let jobID: String
    
    var endpoint: Endpoint {
        
        let body = try? [
            "type":"Job",
            "like":"yes",
            "job_id":jobID
            ].toJSONData()
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "jobseeker-super-like"], body: body)
        
    }
    
    init(jobID: String) {
        self.jobID = jobID
    }
    
}

struct SwipeSuperLikeJobSeekerResponse: DTO {
    
}
