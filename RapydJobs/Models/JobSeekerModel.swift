//
//  JobSeekerModel.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/21/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class JobSeekerModel: Mappable {
    
    
    var description: String?
    var userId: String?
    var minSalaryString: String?
    var maxSalaryString: String?
    var fullName: String?
    var cv: String?
    var gender: String?
    var contact: String?
    var id: Int?
    var dates: [[String:Any]]?
    
    init() { }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        description     <- map["description"]
        userId          <- map["user_id"]
        minSalaryString <- map["min_sal"]
        maxSalaryString <- map["max_sal"]
        fullName        <- map["fullname"]
        cv              <- map["cv"]
        gender          <- map["gender"]
        contact         <- map["contact"]
        id              <- map["id"]
        dates           <- map["dates"]
        
    }
    
    required public init(coder aDecoder: NSCoder) {
    }
    
}
