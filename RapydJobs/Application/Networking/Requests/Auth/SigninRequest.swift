//
//  SigninRequest.swift
//  RapydJobs
//
//  Created by Maroof Khan on 27/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

final class SigninRequest: EndpointProvider {
    
    private enum Constants {
        static let grantType = "password"
        static let clientID = "2"
    }
    
    typealias Response = AuthResponse
    
    private let username: String
    private let password: String
    private let secretsProvider: SecretsProvider
    
    var endpoint: Endpoint {
        
        let body = try? [
            "username": username,
            "password": password,
            "grant_type": Constants.grantType,
            "client_id": Constants.clientID,
            "client_secret": secretsProvider.clientSecret.value
            ].toJSONData()
        
        return Endpoint(api: .rapydPublic, method: .post, path: ["api", "oauth", "token"], body: body)
    }
    
    init(username: String, password: String,
         secretsProvider: SecretsProvider = AppContainer.shared.secretsContainer) {
        self.username = username
        self.password = password
        self.secretsProvider = secretsProvider
    }
}
