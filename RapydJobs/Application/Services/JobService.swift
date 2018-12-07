//
//  JobService.swift
//  RapydJobs
//
//  Created by Maroof Khan on 25/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
protocol JobServiceDelegate: class {
    func created()
    func failuer(error: NetworkError)
}

class JobService {
    private let network: Network
    weak var delegate: JobServiceDelegate?
    
    init(network: Network = .shared, delegate: JobServiceDelegate) {
        self.network = network
        self.delegate = delegate
    }
    
    func create(job: Job) {
        let request = CreateJobRequest(title: job.title, description: job.description, min_salary: "\(job.salary.minimum)", max_salary: "\(job.salary.maximum)", job_type: job.type, contract_length: job.length, related_fields: ["Media", "Journalist"], dates: [Hours(day: "MONDAY", start: "00", End: "12")])
        
        network.request(request) { [weak delegate] result in
            switch result {
            case .success: delegate?.created()
            case .failure(let error): delegate?.failuer(error: error)
            }
        }
    }
}
