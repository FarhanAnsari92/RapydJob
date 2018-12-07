//
//  SwipeLikeEmployer.swift
//  RapydJobs
//
//  Created by Nasir Khan on 13/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class UpdateEmployerRequest: EndpointProvider {
    typealias Response = UpdateEmployerResponse
    
    private let name: String
    private let description: String
    private let website: String
    private let regNumber: String
    private let contact: String
    
    var endpoint: Endpoint {
        
        let body = try? [
            "organization_name":name,
            "description":description,
            "website":website,
            "registration_number":regNumber,
            "contact": contact
            ].toJSONData()
        
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "update-organization"], body: body)
        
    }
    
    init(name: String, description: String, website: String, regNumber: String, contact: String) {
        self.name = name
        self.description = description
        self.website = website
        self.regNumber = regNumber
        self.contact = contact
    }
    
}

struct UpdateEmployerResponse: DTO {
    
}
