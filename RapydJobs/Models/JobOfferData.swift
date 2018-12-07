//
//  JobOfferData.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 10/28/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class JobOfferData: Mappable {

    var id:Int!
    var userId:Int!
    var jobOfferId:Int!
    var title:String!
    var description:String!
    var dates: [UserDateData]?
    var minSalary:Int!
    var maxSalary:Int!
    var jobType:String!
    var contractLength:String!
    var status:String!
    var JobOfferOwnerData: JobOfferOwnerData!
    var userData: JobOfferOwnerData!
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        userId <- map["user_id"]
        jobOfferId <- map["joboffer_id"]
        title <- map["title"]
        dates <- map["dates"]
        description <- map["description"]        
        minSalary <- map["min_salary"]
        maxSalary <- map["max_salary"]
        jobType <- map["job_type"]
        contractLength <- map["contract_length"]
        status <- map["status"]
        JobOfferOwnerData <- map["job_owner"]
        userData <- map["user"]
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        
    }
    
}
