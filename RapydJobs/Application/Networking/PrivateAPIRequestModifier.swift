//
//  PrivateAPIRequestModifier.swift
//  RapydJobs
//
//  Created by Maroof Khan on 27/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

final class PrivateAPIRequestModifier: RequestModifier {
    
    func modify(endpoint: Endpoint) throws -> Endpoint {
        var endpoint = endpoint
        let repo = AppContainer.shared.networkRepository
        if let authorization = repo.authorization {
            endpoint.api.additionalHeaders["Authorization"] = "Bearer \(authorization)"
        }
        return endpoint
    }
}
