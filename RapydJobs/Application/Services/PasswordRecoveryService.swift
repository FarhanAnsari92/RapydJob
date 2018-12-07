//
//  PasswordRecoveryService.swift
//  RapydJobs
//
//  Created by Maroof Khan on 28/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol PasswordRecoveryServiceDelegate: class {
    func proceed()
    func proceed(with token: Token)
    func failed(error: NetworkError)
}

extension PasswordRecoveryServiceDelegate {
    func proceed() { }
    func proceed(with token: Token) { }
}

final class PasswordRecoveryService {
    
    private let network: Network
    
    init(network: Network = .shared) {
        self.network = network
    }
    
    func sendRecovery(to email: String, delegate: PasswordRecoveryServiceDelegate) {
        let request = SendAccountRecoveryRequest(email: email)
        network.request(request) { [weak delegate] result in
            switch result {
            case .success: delegate?.proceed(with: Token(value: "XXX"))
            case .failure(let error): delegate?.failed(error: error)
            }
        }
    }
    
    func update(password: String, confirmPassword: String, delegate: PasswordRecoveryServiceDelegate) {
        delegate.proceed()
    }
}

