//
//  ScheduleInterview.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class ScheduleInterviewRequest: EndpointProvider {
    typealias Response = ScheduleInterviewResponse
    
    private let userID: String
    private let jobID: String
    private let status: String
    private let start: String
    private let end: String
    private let date: String
    
    var endpoint: Endpoint {
        
        let dictionary = [
            "user_id":userID,
            "job_id":jobID,
            "interview_status":status,
            "start_time":start,
            "end_time":end,
            "date":date
        ]
        
        let body = try? JSONSerialization.data( withJSONObject: dictionary, options: [])
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "store-interview"], body: body)
        
    }
    
    init(userID: String, jobID: String, status: String = "scheduled", start: String, end: String, date: String) {
        self.userID = userID
        self.jobID = jobID
        self.status = status
        self.start = start
        self.end = end
        self.date = date
    }
    
}

struct ScheduleInterviewResponse: DTO {
    
}
