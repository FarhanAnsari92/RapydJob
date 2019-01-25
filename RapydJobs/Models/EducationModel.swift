//
//  EducationModel.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/15/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class EducationModel: Mappable {
    
    var description: String?
    var from: String?
    var to: String?
    var id: Int?
    var instituteName: String?
    var grade: String?
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
        instituteName <- map["institute_name"]
        grade <- map["grade"]
        title <- map["title"]
        id <- map["id"]
        userId <- map["user_id"]
        
    }
    
    required public init(coder aDecoder: NSCoder) {
    }
    
}
