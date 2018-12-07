//
//  ShorlistedJobseekersRequest.swift
//  RapydJobs
//
//  Created by Maroof Khan on 28/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

final class ShorlistedJobseekersRequest: EndpointProvider {
    typealias Response = [JobseekerResponseDTO]
    
    var endpoint: Endpoint {
        return Endpoint(api: .rapydPrivate, method: .get, path: ["api", "show-shortlisted-jobseekers", "\(job)"])
    }
    
    let job: Int
    
    init(job: Int) {
        self.job = job
    }
}
