//
//  GenericAPIRequestModifier.swift
//  RapydJobs
//
//  Created by Maroof Khan on 27/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

final class GenericAPIRequestModifier: RequestModifier {
    
    func modify(endpoint: Endpoint) throws -> Endpoint {
        var endpoint = endpoint
        let repo = AppContainer.shared.networkRepository
        ["accept": repo.accept,
         "content-type": repo.contentType].forEach { endpoint.api.additionalHeaders[$0.key] = $0.value }
        return endpoint
    }
}
