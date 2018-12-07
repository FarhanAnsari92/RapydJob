//
//  UpdateEmployerSignup.swift
//  RapydJobs
//
//  Created by Nasir Khan on 12/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class UpdateLanguageRequest: EndpointProvider {
    typealias Response = UpdateLanguageResponse
    
    private let languageID: String
    private let languageName: String
    
    
    var endpoint: Endpoint {
        
        let dictionary = [
            "language":languageName
        ]
        
        let body = try? JSONSerialization.data( withJSONObject: dictionary, options: [])
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "update-language", languageID], body: body)
        
    }
    
    init(languageID: String, languageName: String) {
        self.languageID = languageID
        self.languageName = languageName
        
    }
}

struct UpdateLanguageResponse: DTO {
    
}
