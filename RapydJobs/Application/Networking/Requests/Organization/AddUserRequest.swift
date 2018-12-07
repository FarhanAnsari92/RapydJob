//
//  AddUserRequest.swift
//  RapydJobs
//
//  Created by Maroof Khan on 29/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

final class AddUserRequest: EndpointProvider {
    
    typealias Response = EmptyDTO
    
    var endpoint: Endpoint {
        
        let body = try? [
            "type": type,
            "like": like.rawValue,
            "user_id": user,
            "job_id": job
        ].toJSONData()
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "add-swipe-user"], body: body)
    }
    
    let type: String = "User"
    let like: Like
    let user: String
    let job: String
    
    init(like: Like, user: String, job: String) {
        self.like = like
        self.user = user
        self.job = job
    }
}
