//
//  GetEmployerDetails.swift
//  RapydJobs
//
//  Created by Nasir Khan on 12/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class GetJobSeekerDetailsRequest: EndpointProvider {
    typealias Response = GetJobSeekerDetailsResponse
    
    
    var endpoint: Endpoint {
        
        return Endpoint(api: .rapydPrivate, method: .get, path: ["api", "my-profile-jobseeker"], body: nil)
        
    }
    
    init() {
    }
    
}

struct GetJobSeekerDetailsResponse: DTO {

    
}
