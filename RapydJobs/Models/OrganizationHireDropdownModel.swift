//
//  OrganizationHireDropdownModel.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 12/12/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class OrganizationHireDropdownModel: Mappable {

    //["job_id": 32, "organization_name": Wave Organizations, "job_name": Job Dev]
    var jobId: Int?
    var organizationName: String?
    var jobName: String?
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        jobId <- map["job_id"]
        organizationName <- map["organization_name"]
        jobName <- map["job_name"]
    }
}


