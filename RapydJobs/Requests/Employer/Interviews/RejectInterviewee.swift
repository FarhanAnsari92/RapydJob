//
//  RejectInterviewee.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class RejectIntervieweeRequest: EndpointProvider {
    typealias Response = RejectIntervieweeResponse
    
    private let interviewID: String
    
    var endpoint: Endpoint {
        
        return Endpoint(api: .rapydPrivate, method: .delete, path: ["api", "delete-interview", interviewID], body: nil)
        
    }
    
    init(interviewID: String) {
        self.interviewID = interviewID
    }
    
}

struct RejectIntervieweeResponse: DTO {
    
}
