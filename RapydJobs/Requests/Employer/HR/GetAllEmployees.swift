//
//  GetAllEmployees.swift
//  RapydJobs
//
//  Created by Nasir Khan on 23/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class GetAllEmployeesRequest: EndpointProvider {
    typealias Response = GetAllEmployeesResponse
    
    var endpoint: Endpoint {
        
        return Endpoint(api: .rapydPrivate, method: .get, path: ["api", "managed-employees", "start"], body: nil)
        
    }
    
    init() {
    }
    
}

struct GetAllEmployeesResponse: DTO {
    
}
