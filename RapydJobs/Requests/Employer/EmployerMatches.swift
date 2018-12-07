//
//  EmployerMatches.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//
import Foundation

class EmployerMatchesRequest: EndpointProvider {
    typealias Response = EmployerMatchesResponse
    
    private let jobID: String
    private let limit: String
    
    var endpoint: Endpoint {
        
        let dictionary = [
            "job_id": jobID,
            "limit": limit
        ]
        
        let body = try? JSONSerialization.data( withJSONObject: dictionary, options: [])
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "organization-matches"], body: body)
        
    }
    
    init(jobID: String, limit: String) {
        self.jobID = jobID
        self.limit = limit
    }
    
}

struct EmployerMatchesResponse: DTO {
    let job_matches: [EmployerMatchDTO]?
}

struct EmployerMatchDTO: DTO {
    let id: Int
    let username: String
    let email: String
    let accountType: String
    let profileImage: String
    let createdAt: String
    let updatedAt: String
    let deviceToken: String?
    let device: String?
    let longitude: String?
    let latitude: String?
    let fcm: String?
    let status: String
    let conversationId: String
    let pivot: EmployerMatchPivotDTO
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case accountType = "account_type"
        case profileImage = "profile_image"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deviceToken = "device_token"
        case device
        case longitude
        case latitude
        case fcm
        case status
        case conversationId = "conversation_id"
        case pivot
    }
}

struct EmployerMatchPivotDTO: DTO {
    let jobId: String
    let jobseekerId: Int
    let conversationId: String
    
    enum CodingKeys: String, CodingKey {
        case jobId = "job_id"
        case jobseekerId = "jobseeker_id"
        case conversationId = "conversation_id"
    }
}
