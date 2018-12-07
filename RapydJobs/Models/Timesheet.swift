//
//  Timesheet.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/29/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class Timesheet: Mappable {
    
    var createdAt: String?
    var updatedAt: String?
    var startTime: String?
    var endTime: String?
    var id: Int?
    var timesheetId: String?
    var date: String?
    
    
    init() { }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {

        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        startTime <- map["start_time"]
        endTime <- map["end_time"]
        date <- map["date"]
        timesheetId <- map["timesheet_id"]
        id              <- map["id"]
        
    }
    
    required public init(coder aDecoder: NSCoder) {
    }
    
}
