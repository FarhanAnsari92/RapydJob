//
//  GetInterviewees.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class GetIntervieweesRequest: EndpointProvider {
    typealias Response = GetIntervieweesResponse
    
    private let status: String
    
    var endpoint: Endpoint {
        return Endpoint(api: .rapydPrivate, method: .get, path: ["api", "organization-interview", status], body: nil)
    }
    
    init(status: String) {
        self.status = status
    }
    
}

struct GetIntervieweesResponse: DTO {
    
}
