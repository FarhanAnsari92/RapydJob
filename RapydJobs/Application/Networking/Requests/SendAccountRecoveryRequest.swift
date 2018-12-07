//
//  SendAccountRecoveryRequest.swift
//  RapydJobs
//
//  Created by Maroof Khan on 29/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

final class SendAccountRecoveryRequest: EndpointProvider {
    typealias Response = EmptyDTO
    
    var endpoint: Endpoint {
        return Endpoint(api: .rapydPublic, method: .post, path: ["reset-password"], body: try? ["email": email].toJSONData())
    }
    
    let email: String
    init(email: String) {
        self.email = email
    }
}
