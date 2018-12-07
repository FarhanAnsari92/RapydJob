//
//  ShorlistUserRequest.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 29/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

final class ShorlistUserRequest: EndpointProvider {
    typealias Response = EmptyDTO
    
    var endpoint: Endpoint {
        
        let body = try? [
            "job_id": job,
            "user_id": userID
            ].toJSONData()
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "store-shortlist-jobseekers"], body: body)
    }
    
    let job: String
    let userID: String

    init(job: String, userID: String) {
        self.job = job
        self.userID = userID
    }
}
