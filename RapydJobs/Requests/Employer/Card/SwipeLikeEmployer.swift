//
//  SwipeLikeEmployer.swift
//  RapydJobs
//
//  Created by Nasir Khan on 13/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class SwipeLikeEmployerRequest: EndpointProvider {
    typealias Response = SwipeLikeEmployerResponse
    
    private let userID: String
    private let jobID: String
    private let like: String // Yes or No
    
    var endpoint: Endpoint {
        
        let body = try? [
            "type":"User",
            "like":like,
            "user_id":userID,
            "job_id":jobID
            ].toJSONData()
        
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "add-swipe-user"], body: body)
        
    }
    
    init(userID: String, jobID: String, like: String) {
        self.userID = userID
        self.jobID = jobID
        self.like = like
    }
    
}

struct SwipeLikeEmployerResponse: DTO {
    
}
