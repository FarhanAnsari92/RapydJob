//
//  UpdateEmployerSignup.swift
//  RapydJobs
//
//  Created by Nasir Khan on 12/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class SignupUpdateEmployerRequest: EndpointProvider {
    typealias Response = SignupUpdateEmployerResponse
    
    var endpoint: Endpoint {
        return Endpoint(api: .rapydPrivate, method: .put, path: ["api", "user"], body: data)
    }
    
    static func address(address: String, floor: String?, postal: String) -> SignupUpdateEmployerRequest {
        let body = try! [
            "address": [
                "address": address
            ]
        ].toJSONData()
        return .init(data: body)
    }
    
    static func information(organization: String, registration: String /* Registration */, website: String /* Email */, contact: String /* Phone Number */) -> SignupUpdateEmployerRequest {
        
        let body = try! [
            "organization": [
                "organization_name": organization,
                "description": "//TODO:",
                "website": website,
                "registration_number": registration
            ]
        ].toJSONData()
        return .init(data: body)
        
    }
    
    private let data: Data
    private init(data: Data) {
        
        
        /*
         
         let dictionary = [
         "user_profile_image": [ "profile_image":profileImage ],
         "address": [
         "building_floor": floor,
         "postal_code": postal,
         "address": address
         ],
         "organization": [
         "organization_name": name,
         "description": description,
         "website": website,
         "registration_number": regNumber
         ]
         ]
         
         let body = try? JSONSerialization.data( withJSONObject: dictionary, options: [])
         
         
         */
        
        self.data = data
    }
}

struct SignupUpdateEmployerResponse: DTO {
}
