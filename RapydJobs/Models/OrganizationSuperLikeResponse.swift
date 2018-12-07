//
//  OrganizationSuperLikeResponse.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 10/28/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class OrganizationSuperLikeResponse: Mappable {
    
    var jobseekerId: Any?
    var jobId: Int!
    var conversationId: Int!
    var id: Int!
    
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        jobseekerId <- map["jobseeker_id"]
        jobId <- map["job_id"]
        conversationId <- map["conversation_id"]
        id <- map["id"]
    }
    
    required public init(coder aDecoder: NSCoder) {
        
    }
    
}
