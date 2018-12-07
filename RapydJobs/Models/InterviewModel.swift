//
//  InterviewModel.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 10/28/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class InterviewModel: Mappable {
    
    var interviewId: Int?
    var jobId: Int?
    var jobTitle: String?
    var userId: Int?
    var interviewStatus: String?
    var startTime: String?
    var endTime: String?
    var date: String?
    var fullname: String?
    var profileImage: String?
    var lastExperience: String?
    
    init() { }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        interviewId     <- map["interview_id"]
        jobTitle        <- map["job_title"]
        jobId           <- map["job_id"]
        userId          <- map["user_id"]
        interviewStatus <- map["interview_status"]
        startTime       <- map["start_time"]
        endTime         <- map["end_time"]
        date            <- map["date"]
        fullname        <- map["fullname"]
        profileImage    <- map["profile_image"]
        lastExperience  <- map["last_experience"]
    }
    
    required public init(coder aDecoder: NSCoder) {
        
    }
    
}
