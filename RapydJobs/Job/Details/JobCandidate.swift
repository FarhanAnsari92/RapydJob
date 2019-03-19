//
//  JobCandidate.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 3/20/19.
//  Copyright © 2019 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class JobCandidate: Mappable {
    
    var jobId: Int?
    var matchId: Int?
    var userId: Int?
    var fullName: String?
    var profileImage: String?
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        jobId <- map["job_id"]
        matchId <- map["match_id"]
        userId <- map["user_id"]
        fullName <- map["fullname"]
        profileImage <- map["profile_image"]
    }
    
    //["job_id": 5, "match_id": 2, "user_id": 7, "fullname": Android Seeker, "profile_image": http://ec2-18-191-9-134.us-east-2.compute.amazonaws.com/RapydJobs/storage/profile_image/D5Z9oWMnKeEjbiNea4uuNhiRgxp42jIPQ079piea.jpeg]
}
