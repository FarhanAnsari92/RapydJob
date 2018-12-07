//
//  JobSeekerOffersResponse.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 10/28/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class JobSeekerOffersResponse: Mappable {
    
    var currentPage:String!
    var data: [JobOfferData]!
    var firstPageUrl:String!
    var from:Int!
    var lastPage:Int!
    var lastPageUrl:String!
    var nextPageUrl:String!
    var path:String!
    var perPage:String!
    var prevPageUrl:String!
    var to:Int!
    var total:Int!
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        currentPage  <- map["current_page"]
        data         <- map["data"]
        firstPageUrl <- map["first_page_url"]
        from         <- map["from"]
        lastPage     <- map["last_page"]
        lastPageUrl  <- map["last_page_url"]
        nextPageUrl  <- map["next_page_url"]
        path         <- map["path"]
        perPage      <- map["per_page"]
        prevPageUrl  <- map["prev_page_url"]
        to           <- map["to"]
        total        <- map["total"]
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        
    }
}
