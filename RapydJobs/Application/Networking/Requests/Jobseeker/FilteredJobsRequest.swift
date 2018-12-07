//
//  FilteredJobsRequest.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 29/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

final class FilteredJobsRequest: EndpointProvider {
    typealias Response = [JobResponseDTO]
    
    var endpoint: Endpoint {
        return Endpoint(api: .rapydPrivate, method: .get, path: ["api", "show-filtered-jobs"])
    }
}
