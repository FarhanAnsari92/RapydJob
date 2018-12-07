//
//  JobSeekerMatchesService.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 28/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol JobSeekerMatchesDelegate: class {
    func JobSeekerMatched()
    func failed(error: String)
}


class JobSeekerMatchesService {
    
    let network: Network
    weak var delegate: JobSeekerMatchesDelegate?
    
    init(network: Network = .shared) {
        self.network = network
    }
    
    func getMatches(jobID: String, limit: String) {
        let request = JobSeekerMatchesRequest(limit: limit)
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.JobSeekerMatched()
            case let .failure(error):
                delegate?.failed(error: error.message)
            }
        }
    }
}
