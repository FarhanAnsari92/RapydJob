//
//  GetCardsForEmployer.swift
//  RapydJobs
//
//  Created by Nasir Khan on 13/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class GetCardsForJobSeekerRequest: EndpointProvider {
    typealias Response = GetCardsForJobSeekerResponse
    
    private let apiName: String
    
    // show-filtered-jobs
    // show-shortlisted-jobs
    
    var endpoint: Endpoint {
        
        return Endpoint(api: .rapydPrivate, method: .get, path: ["api", apiName], body: nil)
        
    }
    
    init(apiName: String) {
        self.apiName = apiName
    }
    
}

struct GetCardsForJobSeekerResponse: DTO {
    
}
