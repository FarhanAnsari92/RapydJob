//
//  EmployerOnboardingService.swift
//  RapydJobs
//
//  Created by Maroof Khan on 22/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol EmployerOnboardingServiceDelegate: class {
    func proceed()
    func failure(error: Error)
}

class EmployerOnboardingService {
    private let network: Network
    
    init(network: Network = .shared) {
        self.network = network
    }
    
    func updateInfo(title: String, registration: String, website: URL, contact: String, delegate: EmployerOnboardingServiceDelegate) {
        let body = try? [
            "organization": [
                "organization_name": title,
                "description": "Description is not part of the design, interestingly.",
                "website": website.absoluteString,
                "registration_number": registration
                ]
            ].toJSONData()
        let request = UserUpdateRequest(data: body)
        network.request(request) { [weak delegate] result in
            switch result {
            case .success:
                delegate?.proceed()
            case .failure(let error):
                delegate?.failure(error: error)
            }
        }
    }
    
    func verifyPhone(code: String, delegate: EmployerOnboardingServiceDelegate) {
        if code == "1234" {
            DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(2)) {
                delegate.proceed()
            }
        } else {
            
        }
    }
    
    func updateAddress(floor: String?, postal: String, address: String, delegate: EmployerOnboardingServiceDelegate) {
        let body = try? [
            "address": [
                "building_floor": floor,
                "postal_code": postal,
                "address": address
                ]
            ].toJSONData()
        let request = UserUpdateRequest(data: body)
        network.request(request) { [weak delegate] result in
            switch result {
            case .success:
                delegate?.proceed()
            case .failure(let error):
                delegate?.failure(error: error)
            }
        }
    }
    
    func update(logo: Data, delegate: EmployerOnboardingServiceDelegate) {
        delegate.proceed()
    }
}
