//
//  UpdateEmployerSignup.swift
//  RapydJobs
//
//  Created by Nasir Khan on 12/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class DeleteLanguageRequest: EndpointProvider {
    typealias Response = DeleteLanguageResponse
    
    private let languageID: String
    
    var endpoint: Endpoint {
        
        return Endpoint(api: .rapydPrivate, method: .delete, path: ["api", "delete-language", languageID], body: nil)
        
    }
    
    init(languageID: String) {
        
        self.languageID = languageID
        
    }
}

struct DeleteLanguageResponse: DTO {
    
}
