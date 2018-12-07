//
//  CreateJobService.swift
//  RapydJobs
//
//  Created by Nasir Khan on 17/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol CreateJobDelegate: class {
    func CreatedJob()
    func failed(error: String)
}


class CreateJobService {
    
    let network: Network
    weak var delegate: CreateJobDelegate?
    
    init(network: Network = .shared) {
        self.network = network
    }
    
    func create(title: String, description: String, min_salary: String, max_salary: String, job_type: String, contract_length: String, related_fields: Array<String>, dates: Array<Hours>) {
        let request = CreateJobRequest(title: title, description: description, min_salary: min_salary, max_salary: max_salary, job_type: job_type, contract_length: contract_length, related_fields: related_fields, dates: dates)
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.CreatedJob()
            case let .failure(error):
                delegate?.failed(error: error.message)
            }
        }
    }
}
