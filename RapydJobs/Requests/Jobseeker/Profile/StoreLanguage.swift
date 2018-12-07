//
//  UpdateEmployerSignup.swift
//  RapydJobs
//
//  Created by Nasir Khan on 12/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class StoreLanguageRequest: EndpointProvider {
    typealias Response = StoreLanguageResponse
    
    private let language: Array<Any>
    
    var endpoint: Endpoint {
        
        let dictionary = [
            "languages":language
            ] as [String : Any]
        
        let body = try? JSONSerialization.data( withJSONObject: dictionary, options: [])
        
        return Endpoint(api: .rapydPrivate, method: .put, path: ["api", "store-language"], body: body)
        
    }
    
    init(language: Array<Any>) {

        self.language = language
        
    }
}

struct StoreLanguageResponse: DTO {
    
}
