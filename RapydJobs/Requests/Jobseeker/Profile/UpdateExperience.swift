//
//  UpdateEmployerSignup.swift
//  RapydJobs
//
//  Created by Nasir Khan on 12/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class UpdateExperienceRequest: EndpointProvider {
    typealias Response = UpdateExperienceResponse
    
    private let experienceID: String
    private let title: String
    private let company: String
    private let description: String
    private let to: String
    private let from: String
    
    
    var endpoint: Endpoint {
        
        let dictionary = [
            "title":title,
            "company_name":company,
            "description":description,
            "to":to,
            "from":from,
            
            ]
        
        let body = try? JSONSerialization.data( withJSONObject: dictionary, options: [])
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "update-experience", experienceID], body: body)
        
    }
    
    init(experienceID: String, title: String, company: String, description: String, to: String, from: String) {
        self.experienceID = experienceID
        self.title = title
        self.company = company
        self.description = description
        self.to = to
        self.from = from
        
    }
}

struct UpdateExperienceResponse: DTO {
    
}
