//
//  PhoneVerificationRequest.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 28/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

final class PhoneVerificationRequest: EndpointProvider {
    
    typealias Response = PhoneVerificationResponse
    
    private let contactNumber: String
    
    var endpoint: Endpoint {
        
        let body = try? [
            "contact_number": contactNumber,
            ].toJSONData()
        
        return Endpoint(api: .rapydPrivate, method: .post, path: ["api", "send-sms"], body: body)
    }
    
    init(contactNumber: String) {
        self.contactNumber = contactNumber
    }
}

struct PhoneVerificationResponse: DTO {
    let user_id: Int
    let code: Int
    let updated_at: String
    let created_at: String
    let id: Int
}
