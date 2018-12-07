//
//  GetEmployerDetails.swift
//  RapydJobs
//
//  Created by Nasir Khan on 12/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class GetEmployerDetailsRequest: EndpointProvider {
    typealias Response = GetEmployerDetailsResponse
    
    
    var endpoint: Endpoint {
        
        return Endpoint(api: .rapydPrivate, method: .get, path: ["api", "my-profile-organization"], body: nil)
        
    }
    
    init() {
    }
    
}

struct GetEmployerDetailsResponse: DTO {
    
    let id : String
    let username : String
    let email : String
//    let accountType : AccountType
    let profileImage : String
    let token : String
    let longitude : String
    let Latitude : String
    let status : String
    let name : String
    let regNumber : String
    let website : String
    let contact : String
    
}
