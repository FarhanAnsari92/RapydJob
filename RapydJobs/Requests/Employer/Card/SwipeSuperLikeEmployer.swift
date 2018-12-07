//
//  SwipeSuperLikeEmployer.swift
//  RapydJobs
//
//  Created by Nasir Khan on 13/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class SwipeSuperLikeEmployerRequest: EndpointProvider {
    typealias Response = SwipeSuperLikeEmployerResponse
    
    private let userID: String
    private let jobID: String
    
    var endpoint: Endpoint {
        
        let body = try? [
            "type":"User",
            "user_id":userID,
            "job_id":jobID
            ].toJSONData()
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "organization-super-like"], body: body)
        
    }
    
    init(userID: String, jobID: String) {
        self.userID = userID
        self.jobID = jobID
    }
    
}

struct SwipeSuperLikeEmployerResponse: DTO {
//    "conversation_id" = 143;
//    "created_at" = "2018-10-25 23:19:08";
//    id = 143;
//    "job_id" = 34;
//    "jobseeker_id" = 87;
//    "updated_at" = "2018-10-25 23:19:08";
    
    let conversationId: Int    
    
}
