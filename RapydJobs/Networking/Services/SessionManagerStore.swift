//
//  SessionManagerStore.swift
//  Networking
//
//  Created by Maroof Khan on 07/05/2018.
//  Copyright © 2018 for RapydJobs. All rights reserved.
//

import Foundation

final class SessionManagerStore {
    private var sessionManagers: [AnyHashable: URLSession] = [:]
    
    func sessionManager(for baseUrl: BaseURL) -> URLSession {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        let key = baseUrl.host
        if let sessionManager = sessionManagers[key] {
            return sessionManager
        }
        
        let manager = URLSession(configuration: .default)
        sessionManagers[key] = manager
        
        return manager
    }
}
