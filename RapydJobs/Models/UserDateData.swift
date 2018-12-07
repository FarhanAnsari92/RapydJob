//
//  UserDateData.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 10/28/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper


class UserDateData: Mappable {
    
    var day: String!
    var startTime: String!
    var endTime: String!
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        day <- map["day"]
        startTime <- map["start_time"]
        endTime <- map["end_time"]
    }
    
    required public init(coder aDecoder: NSCoder) {
        
    }
}
