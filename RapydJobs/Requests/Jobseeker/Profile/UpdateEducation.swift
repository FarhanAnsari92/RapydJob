//
//  UpdateEmployerSignup.swift
//  RapydJobs
//
//  Created by Nasir Khan on 12/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class UpdateEducationRequest: EndpointProvider {
    typealias Response = UpdateEducationResponse
    
    private let educationID: String
    private let title: String
    private let institute: String
    private let description: String
    private let to: String
    private let from: String
    
    
    var endpoint: Endpoint {
        
        let dictionary = [
            "title":title,
            "institute_name":institute,
            "description":description,
            "to":to,
            "from":from,
            
        ]
        
        let body = try? JSONSerialization.data( withJSONObject: dictionary, options: [])
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "update-education", educationID], body: body)
        
    }
    
    init(educationID: String, title: String, institute: String, description: String, to: String, from: String) {
        self.educationID = educationID
        self.title = title
        self.institute = institute
        self.description = description
        self.to = to
        self.from = from
    }
}

struct UpdateEducationResponse: DTO {
    
}
