//
//  UpdateEmployerSignup.swift
//  RapydJobs
//
//  Created by Nasir Khan on 12/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class DeleteEducationRequest: EndpointProvider {
    typealias Response = DeleteEducationResponse
    
    private let educationID: String
    
    var endpoint: Endpoint {
        
        return Endpoint(api: .rapydPrivate, method: .delete, path: ["api", "delete-education", educationID], body: nil)
        
    }
    
    init(educationID: String) {
        
        self.educationID = educationID
        
    }
}

struct DeleteEducationResponse: DTO {
    
}
