//
//  JobDetailModel.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 12/16/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class JobDetailModel: Mappable {
    
    var address: AddressModel?
    var maxSalary: Int?
    var minSalary: Int?
    var description: String?
    var profileImage: String?
    var organizationName: String?
    var jobType: String?
    var status: String?
    var contractLength: String?
    var title: String?
    var dates: [UserDateData]?
    
    init(){ }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        self.address <- map["address"]
        self.maxSalary <- map["max_salary"]
        self.minSalary <- map["min_salary"]
        self.description <- map["description"]
        self.profileImage <- map["profile_image"]
        self.organizationName <- map["organization_name"]
        self.jobType <- map["job_type"]
        self.status <- map["status"]
        self.contractLength <- map["contract_length"]
        self.title <- map["title"]
        self.dates <- map["dates"]
    }
    
    
}
