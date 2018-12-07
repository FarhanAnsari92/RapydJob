//
//  UpdateEmployerSignup.swift
//  RapydJobs
//
//  Created by Nasir Khan on 12/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class StoreEducationRequest: EndpointProvider {
    typealias Response = StoreLanguageResponse
    
    private let education: Array<Any>
    
    var endpoint: Endpoint {
        
        let dictionary = [
            "education":education
            ] as [String : Any]
        
        let body = try? JSONSerialization.data( withJSONObject: dictionary, options: [])
        
        return Endpoint(api: .rapydPrivate, method: .put, path: ["api", "store-education"], body: body)
        
    }
    
    init(education: Array<Any>) {
        
        self.education = education
        
    }
}

struct StoreEducationResponse: DTO {
    
}
