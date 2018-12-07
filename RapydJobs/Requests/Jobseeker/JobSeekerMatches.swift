//
//  EmployerMatches.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class JobSeekerMatchesRequest: EndpointProvider {
    typealias Response = JobSeekerMatchesResponse
    
    private let limit: String
    
    var endpoint: Endpoint {
        
        return Endpoint(api: .rapydPrivate, method: .get, path: ["api", "jobseeker-matches", limit], body: nil)
        
    }
    
    init(limit: String) {
        self.limit = limit
    }
    
}

struct JobSeekerMatchesResponse: DTO {
    let job_matches: [JobSeekerMatchDTO]
}

struct JobSeekerMatchDTO: DTO {
    let id: Int
    let username: String
    let email: String
    let account_type: String
    let profile_image: String
    let created_at: String
    let updated_at: String
    let device_token: String
    let device: String
    let longitude: String
    let latitude: String
    let fcm: String
    let status: String
    let conversation_id: String
    let pivot: JobSeekerMatchPivotDTO
}

struct JobSeekerMatchPivotDTO: DTO {
    let job_id: String
    let jobseeker_id: Int
    let conversation_id: String
}
