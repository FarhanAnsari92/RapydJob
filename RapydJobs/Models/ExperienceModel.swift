//
//  ExperienceModel.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/15/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class ExperienceModel: Mappable {
    
    /*
     "company_name" = Bdbdbdbd;
     description = "I will be there at noon";
     from = "2018-06-04";
     id = 2;
     title = Dhdhgdg;
     to = "2018-10-28";
     "user_id" = 7;
     */
    
    var description: String?
    var from: String?
    var to: String?
    var id: Int?
    var companyName: String?
    var title: String?
    var userId: Int?
    var duration: String {
        return "\(self.from ?? "") - \(self.to ?? "")"
    }
    
    init() { }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        
        description <- map["description"]
        from <- map["from"]
        to <- map["to"]
        companyName <- map["company_name"]
        title <- map["title"]
        id <- map["id"]
        userId <- map["user_id"]
        
    }
    
    required public init(coder aDecoder: NSCoder) {
    }
    
}
