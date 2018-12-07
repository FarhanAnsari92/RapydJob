//
//  UserUpdateRequest.swift
//  RapydJobs
//
//  Created by Maroof Khan on 27/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

final class UserUpdateRequest: EndpointProvider {
    
    typealias Response = EmptyDTO
    
    let data: Data?
    var endpoint: Endpoint {
        return Endpoint(api: .rapydPrivate, method: .put, path: ["api", "user"], body: data)
    }
    
    init(data: Data?) {
        self.data = data
    }
}
