//
//  EmployerMatchesService.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol EmployerMatchesDelegate: class {
    func EmployerMatched()
    func failed(error: String)
}


class EmployerMatchesService {
    
    let network: Network
    weak var delegate: EmployerMatchesDelegate?
    
    init(network: Network = .shared) {
        self.network = network
    }
    
    func getMatches(jobID: String, limit: String) {
        let request = EmployerMatchesRequest(jobID: jobID , limit: limit)
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.EmployerMatched()
            case let .failure(error):
                delegate?.failed(error: error.message)
            }
        }
    }
}
