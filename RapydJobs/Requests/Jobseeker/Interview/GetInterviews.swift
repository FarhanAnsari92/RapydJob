//
//  GetCardsForEmployer.swift
//  RapydJobs
//
//  Created by Nasir Khan on 13/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class GetInterviewsRequest: EndpointProvider {
    typealias Response = GetInterviewsResponse
    
    private let limit: String 
    
    var endpoint: Endpoint {
        
        return Endpoint(api: .rapydPrivate, method: .get, path: ["api", limit], body: nil)
        
    }
    
    init(limit: String) {
        self.limit = limit
    }
    
}

struct GetInterviewsResponse: DTO {
    
}
