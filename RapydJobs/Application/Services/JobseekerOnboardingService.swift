//
//  JobseekerOnboardingService.swift
//  RapydJobs
//
//  Created by Maroof Khan on 23/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol JobseekerOnboardingServiceDelegate: class {
    func proceed()
    func failure(error: Error)
}

class JobseekerOnboardingService {
    private let network: Network
    
    init(network: Network = .shared) {
        self.network = network
    }
    
    func updateProfile(name: String, dob: Date, contact: String, gender: Gender,
                       description: String, delegate: JobseekerOnboardingServiceDelegate) {
        let body = try? [
            "jobseeker": [
                "fullname": name,
                "dob": DateFormatter.format(date: dob),
                "contact": contact,
                "gender": gender.rawValue,
                "description": description
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
    
    func updateWorkProfile(address: String, range: Slab<Double>, releated: String, delegate: JobseekerOnboardingServiceDelegate) {
        delegate.proceed()
    }
    
    func verifyPhone(code: String, delegate: JobseekerOnboardingServiceDelegate) {
        delegate.proceed()
    }
    
    func update(experiences: [Experience], delegate: JobseekerOnboardingServiceDelegate) {
        let body = try? [
            "experience": experiences.map {
                return [
                    "title": $0.title,
                    "company_name": $0.company,
                    "description": $0.description,
                    "to": DateFormatter.standard.string(from: $0.slab.maximum),
                    "from": DateFormatter.standard.string(from: $0.slab.minimum)
                ]
            }
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
    
    func update(education: [Education], delegate: JobseekerOnboardingServiceDelegate) {
        let body = try? [
            "education": education.map {
                return [
                    "title": $0.title,
                    "institute_name": $0.institution,
                    "description": $0.description,
                    "to": DateFormatter.standard.string(from: $0.slab.maximum),
                    "from": DateFormatter.standard.string(from: $0.slab.minimum)
                ]
            }
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
    
    func update(languages: [Language], delegate: JobseekerOnboardingServiceDelegate) {
        let body = try? [
            "languages": languages.map {
                return [
                    "language": $0.title,
                    "level": $0.expertise.rawValue
                ]
            }
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
    
    func upload(cv: Data, delegate: JobseekerOnboardingServiceDelegate) {
        delegate.proceed()
    }
    
    func upload(display: Data, delegate: JobseekerOnboardingServiceDelegate) {
        delegate.proceed()
    }
}
