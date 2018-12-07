//
//  UpdateInterview.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation


class UpdateInterviewRequest: EndpointProvider {
    typealias Response = UpdateInterviewResponse
    
    private let review: String
    private let status: String
    private let interviewID: String
    
    var endpoint: Endpoint {
        
        let dictionary = [
            "review":review,
            "status":status
        ]
        
        let body = try? JSONSerialization.data( withJSONObject: dictionary, options: [])
        
        return Endpoint(api: .rapydPrivate, method: .put, path: ["api", "update-interview", interviewID], body: body)
        
    }
    
    init(review: String, status: String, interviewID: String) {
        self.review = review
        self.status = status
        self.interviewID = interviewID
    }
    
}

struct UpdateInterviewResponse: DTO {
    
}
