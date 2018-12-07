//
//  SeekerReview.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/15/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class SeekerReview: Mappable {
    var from: JobOfferOwnerData?
    var id:Int?
    var review: String?
    var star: Double?
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        from             <- map["from"]
        id               <- map["id"]
        review           <- map["review"]
        star             <- map["star"]
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        
    }
}
