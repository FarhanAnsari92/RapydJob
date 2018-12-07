//
//  UpdateRelatedField.swift
//  RapydJobs
//
//  Created by Nasir Khan on 24/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class UpdateRelatedFieldRequest: EndpointProvider {
    typealias Response = UpdateRelatedFieldResponse
    
    private let relatedFields: Array<String>
    
    var endpoint: Endpoint {
        
        let dictionary = [
            "related_fields": relatedFields
            
            ] as [String : Any]
        
        let body = try? JSONSerialization.data( withJSONObject: dictionary, options: [])
        
        return Endpoint(api: .rapydPrivate, method: .put, path: ["api", "update-jobseeker-relatedfield"], body: body)
        
    }
    
    init(relatedFields: Array<String>) {
        self.relatedFields = relatedFields
    }
    
}

struct UpdateRelatedFieldResponse: DTO {
    
}
