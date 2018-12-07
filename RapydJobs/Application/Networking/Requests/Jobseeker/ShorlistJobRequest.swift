//
//  ShorlistJobRequest.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 29/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

final class ShorlistJobRequest: EndpointProvider {
    typealias Response = EmptyDTO
    
    var endpoint: Endpoint {
        
        let body = try? [
            "job_id": job
            ].toJSONData()
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "store-shortlist-jobs"], body: body)
    }
    
    let job: String
    
    init(job: String) {
        self.job = job
    }
}
