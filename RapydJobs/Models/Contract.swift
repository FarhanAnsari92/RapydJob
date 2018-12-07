//
//  Contract.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/2/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class Contract: Mappable {
    
    var fileName: String!
    var contractId: Int!
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        fileName <- map["file"]
        contractId <- map["id"]
    }
    
    required public init(coder aDecoder: NSCoder) {
        
    }
    
}
