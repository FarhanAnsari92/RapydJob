//
//  GetCardsForEmployer.swift
//  RapydJobs
//
//  Created by Nasir Khan on 13/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class GetJobOffersRequest: EndpointProvider {
    typealias Response = GetJobOffersResponse
    
    private let type: String // hired, pending, unsuccessful
    private let limit: String
    
    var endpoint: Endpoint {
        
        return Endpoint(api: .rapydPrivate, method: .get, path: ["api", limit, type], body: nil)
        
    }
    
    init(type: String, limit: String) {
        self.type = type
        self.limit = limit
    }
    
}

struct GetJobOffersResponse: DTO {
    
}
