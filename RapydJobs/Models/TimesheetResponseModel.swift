//
//  TimesheetResponseModel.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/29/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class TimesheetResponseModel: Mappable {
    //"job_name": Latest Job Dev, "id": 7, "created_at": 2018-11-28 19:13:46]]]
    //["jobseeker_id": 24, "status": update, "job_id": 32, "hourly_rate": 2, "updated_at": 2018-11-28 19:22:11, "timesheets"
    
    var jobName: String?
    var id: Int?
    var jobseekerId: Int?
    var status: String?
    var jobId: Int?
    var hourlyRate: String?
    var updatedAt: String?
    var createdAt: String?
    var totalAmount: Double?
    var timesheets: [Timesheet]?
    
    init() { }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        createdAt <- map["created_at"]
        jobName <- map["job_name"]
        id              <- map["id"]
        jobseekerId <- map["jobseeker_id"]
        status <- map["status"]
        jobId <- map["job_id"]
        hourlyRate <- map["hourly_rate"]
        updatedAt <- map["updated_at"]
        timesheets <- map["timesheets"]
        totalAmount <- map["total_amount"]
        
        
        
    }
    
    required public init(coder aDecoder: NSCoder) {
    }
    
}
