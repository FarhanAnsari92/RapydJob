//
//  AppContainer.swift
//  RapydJobs
//
//  Created by Maroof Khan on 27/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

final class AppContainer {
    
    static let shared: AppContainer = .init()
    
    let user: UserContainer
    let job: JobContainer
    let secretsContainer: SecretsContainer
    let networkRepository: NetworkRepository
    
    private init(user: UserContainer = .init(),
                 job: JobContainer = .init(),
                 networkRepository: NetworkRepository = AppNetworkRepository(),
                 secretsContainer: SecretsContainer = .init()) {
        
        self.user = user
        self.job = job
        self.secretsContainer = secretsContainer
        self.networkRepository = networkRepository
    }
    
    var isAnyUserSignedIn: Bool {
        return user.token != nil
    }
}
