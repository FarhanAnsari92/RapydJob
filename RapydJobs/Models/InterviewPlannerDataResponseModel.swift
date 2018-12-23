//
//  InterviewPlannerDataResponseModel.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 12/21/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class InterviewPlannerDataResponseModel: Mappable {
    
    var jobName: String?
    var candidateName: String?
    var startTime: String?
    var endTime: String?
    var dayOfMonth: String?
    var color: String?
    
    init() { }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        jobName <- map["job_name"]
        candidateName <- map["candidate_name"]
        startTime <- map["startTime"]
        endTime <- map["endTime"]
        dayOfMonth <- map["dayOfMonth"]
        color <- map["color"]
    }

}
