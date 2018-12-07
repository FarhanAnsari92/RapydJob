//
//  Signup.swift
//  RapydJobs
//
//  Created by Maroof Khan on 09/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class SignupRequest: EndpointProvider {
    typealias Response = AuthResponse
    
    private let username: String
    private let email: String
    private let password: String
    private let confirmPassword: String
    private let account: Account
    
    var endpoint: Endpoint {
        
        let body = try? [
            "username": username,
            "email": email,
            "password": password,
            "c_password": confirmPassword,
            "account_type": account.rawValue
        ].toJSONData()
        return Endpoint(api: .rapydPublic, method: .post, path: ["api", "user"], body: body)
    }
    
    init(username: String, email: String, password: String, confirmPassword: String, account: Account) {
        self.username = username
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
        self.account = account
    }
}
