//
//  OrganizationJob.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/3/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class OrganizationJob: Mappable {
    
    var contractLength: String!
    var dates: [UserDateData]!
    var description: String!
    var id: Int!
    var jobType: String!
    var jobsRelatedField: [[String: Any]]!
    var maxSalary: Int!
    var minSalary: Int!
    var status: String!
    var title: String!
    var userId: Int!
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        contractLength <- map["contract_length"]
        dates <- map["dates"]
        description <- map["description"]
        id <- map["id"]
        jobType <- map["job_type"]
        jobsRelatedField <- map["jobs_relateedfield"]
        maxSalary <- map["max_salary"]
        minSalary <- map["min_salary"]
        status <- map["status"]
        title <- map["title"]
        userId <- map["user_id"]
    }
    
    required public init(coder aDecoder: NSCoder) {
        
    }
    
}
