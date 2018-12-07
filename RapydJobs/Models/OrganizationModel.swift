//
//  OrganizationModel.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 10/26/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class OrganizationModel: Mappable {
    
    /*
     "id" : 32,
     "website" : "androi.com",
     "organization_name" : "Android Organization",
     "contact" : "(799) 794-8949",
     "user_id" : "75",
     "registration_number" : "AGJ2881C"
     */
    var organizationId: Int?
    var website: String?
    var organizationName: String?
    var contact: String?
    var userId: String?
    var registrationNumber: String?
    
    init() { }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        organizationId     <- map["id"]
        website            <- map["website"]
        organizationName   <- map["organization_name"]
        contact            <- map["contact"]
        userId             <- map["user_id"]
        registrationNumber <- map["registration_number"]
    }
    
    
}
