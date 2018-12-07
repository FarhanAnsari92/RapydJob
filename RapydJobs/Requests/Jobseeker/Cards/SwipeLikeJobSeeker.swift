//
//  SwipeLikeEmployer.swift
//  RapydJobs
//
//  Created by Nasir Khan on 13/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class SwipeLikeJobSeekerRequest: EndpointProvider {
    typealias Response = SwipeLikeJobSeekerResponse
    
    private let jobID: String
    private let like: String // Yes or No
    
    var endpoint: Endpoint {
        
        let body = try? [
            "type":"Job",
            "like":like,
            "job_id":jobID
            ].toJSONData()
        
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "add-swipe-job"], body: body)
        
    }
    
    init(jobID: String, like: String) {
        self.jobID = jobID
        self.like = like
    }
    
}

struct SwipeLikeJobSeekerResponse: DTO {
    
}
