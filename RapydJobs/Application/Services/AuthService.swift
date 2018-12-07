//
//  AuthService.swift
//  RapydJobs
//
//  Created by Maroof Khan on 27/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol AuthServiceDelegate: class {
    func signedIn(with token: Token)
    func signedUp(with token: Token, account: Account)
    func phoneVerified(with data: PhoneVerificationResponse)
    func failed(error: NetworkError)
}

extension AuthServiceDelegate {
    func signedIn(with token: Token) { }
    func signedUp(with token: Token, account: Account) { }
}

final class AuthService {
    
    private weak var delegate: AuthServiceDelegate?
    private let network: Network
    
    init(delegate: AuthServiceDelegate, network: Network = .shared) {
        self.delegate = delegate
        self.network = network
    }
    
    func signup(username: String, email: String, password: String, confirmPassword: String, account: Account) {
        let request = SignupRequest(username: username,
                                    email: email,
                                    password: password,
                                    confirmPassword: confirmPassword,
                                    account: account)
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                AppContainer.shared.user.save(username: dto.username)
                AppContainer.shared.user.save(email: dto.email)
                AppContainer.shared.user.save(accountType: dto.account_type)
                AppContainer.shared.user.save(profileImage: dto.profile_image)
                delegate?.signedUp(with: Token(value: dto.access_token), account: account)
            case let .failure(error):
                delegate?.failed(error: error)
            }
        }
    }
    
    func signin(username: String, password: String) {
        let request = SigninRequest(username: username, password: password)
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                AppContainer.shared.user.save(username: dto.username)
                AppContainer.shared.user.save(email: dto.email)
                AppContainer.shared.user.save(accountType: dto.account_type)
                AppContainer.shared.user.save(profileImage: dto.profile_image)
                delegate?.signedIn(with: Token(value: dto.access_token))
            case let .failure(error):
                delegate?.failed(error: error)
            }
        }
    }
    
    func verifyPhone(phoneNumber: String) {
        let request = PhoneVerificationRequest(contactNumber: phoneNumber)
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.phoneVerified(with: dto)
            case let .failure(error):
                delegate?.failed(error: error)
            }
        }
    }
}
