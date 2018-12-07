//
//  LanguageModel.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/15/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class LanguageModel: Mappable {
    
    var id: Int?
    var userId: Int?
    var language: String?
    var level: String?
    
    init() { }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        
        id <- map["id"]
        userId <- map["user_id"]
        language <- map["language"]
        level <- map["level"]
        
    }
    
    required public init(coder aDecoder: NSCoder) {
    }
    
}
