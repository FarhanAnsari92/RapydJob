//
//  API.swift
//  Networking
//
//  Created by Maroof Khan on 07/05/2018.
//  Copyright © 2018 for RapydJobs. All rights reserved.
//

import Foundation

public struct API {
    let baseURL: BaseURL
    let path: [String]
    let headers: [String: String?]
    let requestModifiers: [RequestModifier]
    var additionalHeaders: [String: String?]
    
    init(baseURL: BaseURL, path: [String] = [], headers: [String: String?] = [:], requestModifiers: [RequestModifier] = [], additionalHeaders: [String: String?] = [:]) {
        self.baseURL = baseURL
        self.path = path
        self.headers = headers
        self.requestModifiers = requestModifiers
        self.additionalHeaders = additionalHeaders
    }
}

