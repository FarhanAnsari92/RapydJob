//
//  PlannerDataResponseModel.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 12/18/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class PlannerDataResponseModel: Mappable {
    
    var color: String?
    var endTime: String?
    var startTime: String?
    var jobName: String?
    var dayOfMonth: String?
    
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        color <- map["color"]
        endTime <- map["endTime"]
        startTime <- map["startTime"]
        jobName <- map["name"]
        dayOfMonth <- map["dayOfMonth"]
    }
    
    init() { }
    
}
