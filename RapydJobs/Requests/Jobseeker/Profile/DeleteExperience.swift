//
//  UpdateEmployerSignup.swift
//  RapydJobs
//
//  Created by Nasir Khan on 12/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class DeleteExperienceRequest: EndpointProvider {
    typealias Response = DeleteExperienceResponse
    
    private let experienceID: String
    
    var endpoint: Endpoint {
        
        return Endpoint(api: .rapydPrivate, method: .delete, path: ["api", "delete-experience", experienceID], body: nil)
        
    }
    
    init(experienceID: String) {
        
        self.experienceID = experienceID
        
    }
}

struct DeleteExperienceResponse: DTO {
    
}
