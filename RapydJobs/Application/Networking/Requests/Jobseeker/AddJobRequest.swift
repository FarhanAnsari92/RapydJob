//
//  AddJobRequest.swift
//  RapydJobs
//
//  Created by Maroof Khan on 29/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

final class AddJobRequest: EndpointProvider {
    typealias Response = EmptyDTO
    
    var endpoint: Endpoint {
        
        let body = try? [
            "type": type,
            "like": like.rawValue,
            "job_id": job
            ].toJSONData()
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "add-swipe-job"], body: body)
    }
    
    let type: String = "Job"
    let like: Like
    let job: String
    
    init(like: Like, job: String) {
        self.like = like
        self.job = job
    }
}
