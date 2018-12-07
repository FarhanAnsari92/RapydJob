//
//  JobOfferOwnerData.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 10/28/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class JobOfferOwnerData: Mappable {
    
    var id:Int!
    var username: String!
    var email:String!
    var accountType:String!
    var profileImage:String!
    var deviceToken:String!
    var device:String!
    var longitude:String!
    var latitude:String!
    var fcm:String!
    var status:String!
    var passwordToken:String!

    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        id             <- map["id"]
        username       <- map["username"]
        email          <- map["email"]
        accountType    <- map["account_type"]
        profileImage   <- map["profile_image"]
        device         <- map["device"]
        longitude      <- map["longitude"]
        latitude       <- map["latitude"]
        fcm            <- map["fcm"]
        status         <- map["status"]
        passwordToken  <- map["password_token"]
    }
    
    required public init(coder aDecoder: NSCoder) {
        
    }
}



