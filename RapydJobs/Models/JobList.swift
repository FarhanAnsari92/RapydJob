//
//  JobList.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 10/29/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class JobList: Mappable {
    
    var title: String!
    var id: Int!
    
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        id <- map["id"]
    }
    
    required public init(coder aDecoder: NSCoder) {
        
    }
    
}
