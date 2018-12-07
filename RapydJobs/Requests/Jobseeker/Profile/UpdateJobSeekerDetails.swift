//
//  UpdateEmployerSignup.swift
//  RapydJobs
//
//  Created by Nasir Khan on 12/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class UpdateJobseekerDetailsRequest: EndpointProvider {
    typealias Response = UpdateJobseekerDetailsResponse
    
    private let fullName: String
    private let dob: String
    private let contact: String
    private let gender: String
    private let description: String
    private let maxSalary: String
    private let minSalary: String
    
    
    var endpoint: Endpoint {
        
        let dictionary = [
            "fullname":fullName,
            "dob":dob,
            "contact":contact,
            "gender":gender,
            "description":description,
            "max_sal":maxSalary,
            "min_sal":minSalary
            ]
        
        let body = try? JSONSerialization.data( withJSONObject: dictionary, options: [])
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "update-jobseeker"], body: body)
        
    }
    
    init(fullName: String, dob: String, contact: String, gender: String, description: String, maxSalary: String, minSalary: String) {
        self.fullName = fullName
        self.dob = dob
        self.contact = contact
        self.gender = gender
        self.description = description
        self.maxSalary = maxSalary
        self.minSalary = minSalary
        
    }
}

struct UpdateJobseekerDetailsResponse: DTO {
    
}
