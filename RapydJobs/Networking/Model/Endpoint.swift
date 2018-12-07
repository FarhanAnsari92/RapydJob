//
//  Endpoint.swift
//  Networking
//
//  Created by Maroof Khan on 07/05/2018.
//  Copyright © 2018 for RapydJobs. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
}

public struct Endpoint {
    private let method: HTTPMethod
    private let path: [String]
    private let query: [String: String]
    private let timeout: TimeInterval?
    private let body: Data?
    var api: API
    
    public init(api: API,
                method: HTTPMethod,
                path: [String],
                query: [String: String] = [:],
                timeout: TimeInterval? = nil,
                body: Data? = nil) {
        
        self.api = api
        self.method = method
        self.path = path
        self.query = query
        self.timeout = timeout
        self.body = body
    }
    
    private var url: URL {
        var components = URLComponents()
        components.scheme = api.baseURL.scheme
        components.host = api.baseURL.host
        components.port = api.baseURL.port
        components.path = "/" + (api.path + path).joined(separator: "/")
        components.queryItems = query.map { URLQueryItem(name: $0, value: $1) }
        
        // (for interview purposes) According to `NSURLComponents`' documention, it is impossible this would ever be nil.
        return components.url!
    }
    
    func modifiedURLRequest() throws -> URLRequest {
        let modifiedEndpoint = try api.requestModifiers
            .reduce(self) { try $1.modify(endpoint: $0) }
        return try modifiedEndpoint.urlRequest()
    }
    
    func urlRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        
        try request.setHeaders(api.headers)
        try request.setHeaders(api.additionalHeaders)
        
        if let body = body {
            request.allHTTPHeaderFields?["Content-Type"] = "application/json"
            request.httpBody = body
        }
        
        if let timeout = timeout {
            request.timeoutInterval = timeout
        }
        
        return request
    }
    
}

