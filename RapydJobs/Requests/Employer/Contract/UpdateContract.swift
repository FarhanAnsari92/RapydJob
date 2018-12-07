//
//  HireEmployee.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class UpdateContractRequest: EndpointProvider {
    typealias Response = UpdateContractResponse
    
    private let contractID: String
    private let jobSeekerID: String
    
    var endpoint: Endpoint {
        
        let dictionary = [
            "signed_by":jobSeekerID
        ]
        
        let body = try? JSONSerialization.data( withJSONObject: dictionary, options: [])
        
        return Endpoint(api: .rapydPrivate, method: .put, path: ["api", "update-contract", contractID], body: body)
        
    }
    
    init(jobSeekerID: String, contractID: String) {
        self.contractID = contractID
        self.jobSeekerID = jobSeekerID
    }
    
}

struct UpdateContractResponse: DTO {
    
}
