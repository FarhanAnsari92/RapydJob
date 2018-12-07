//
//  EndpointProvider.swift
//  Networking
//
//  Created by Maroof Khan on 07/05/2018.
//  Copyright © 2018 for RapydJobs. All rights reserved.
//

import Foundation

public protocol EndpointProvider {
    associatedtype Response: DTO
    var endpoint: Endpoint { get }
}
