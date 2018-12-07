//
//  UpdateEmployerSignup.swift
//  RapydJobs
//
//  Created by Nasir Khan on 12/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class StoreExperienceRequest: EndpointProvider {
    typealias Response = StoreExperienceResponse
    
    private let experience: Array<Any>
    
    var endpoint: Endpoint {
        
        let dictionary = [
            "experience":experience
            ] as [String : Any]
        
        let body = try? JSONSerialization.data( withJSONObject: dictionary, options: [])
        
        return Endpoint(api: .rapydPrivate, method: .put, path: ["api", "store-experience"], body: body)
        
    }
    
    init(experience: Array<Any>) {
        
        self.experience = experience
        
    }
}

struct StoreExperienceResponse: DTO {
    
}
