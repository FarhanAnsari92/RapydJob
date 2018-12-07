//
//  URLRequest+Networking.swift
//  Networking
//
//  Created by Maroof Khan on 07/05/2018.
//  Copyright © 2018 for RapydJobs. All rights reserved.
//

import Foundation

extension URLRequest {
    
    mutating func setHeaders(_ headers: [String: String?]) throws {
        
        let failedHeaders: [String] = headers.compactMap {
            if let value = $0.value {
                setValue(value, forHTTPHeaderField: $0.key)
                return nil
            } else {
                return $0.key
            }
        }
        
        if !failedHeaders.isEmpty {
            throw NSError(domain: "networking",
                          code: 101,
                          userInfo: [ NSLocalizedDescriptionKey: "headers missing: \(failedHeaders)"]
            )
        }
    }
}

