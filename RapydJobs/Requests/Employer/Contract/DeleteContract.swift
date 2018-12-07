//
//  CreateJob.swift
//  RapydJobs
//
//  Created by Nasir Khan on 17/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class DeleteContractRequest: EndpointProvider {
    typealias Response = DeleteContractResponse
    
    private let contractID: String
    
    var endpoint: Endpoint {
        
        return Endpoint(api: .rapydPrivate, method: .delete, path: ["api", "delete-contract", contractID], body: nil)
        
    }
    
    init(contractID: String) {
        self.contractID = contractID
    }
    
}

struct DeleteContractResponse: DTO {
    
}
