//
//  HireEmployee.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class GetSignedContractRequest: EndpointProvider {
    typealias Response = GetSignedContractResponse
    
    var endpoint: Endpoint {
        
        return Endpoint(api: .rapydPrivate, method: .delete, path: ["api", "signed-contract"], body: nil)
        
    }
    
    init() {
    }
    
}

struct GetSignedContractResponse: DTO {
    
}
