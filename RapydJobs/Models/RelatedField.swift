//
//  RelatedField.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/21/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class RelatedField: Mappable {
    
    var relatedField: String?
    
    init() { }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        relatedField     <- map["related_field"]        
    }
    
    required public init(coder aDecoder: NSCoder) {
    }
    
}
