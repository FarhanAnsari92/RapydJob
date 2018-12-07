//
//  GetEmployerJobsService.swift
//  RapydJobs
//
//  Created by Nasir Khan on 17/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol GetEmployerJobsDelegate: class {
    func GotEmployerJobs()
    func failed(error: String)
}


class GetEmployerJobsService {
    
    let network: Network
    weak var delegate: GetEmployerJobsDelegate?
    
    init(network: Network = .shared) {
        self.network = network
    }
    
    func getJobs(numberOfJobs: String) {
        let request = GetEmployerJobsRequest(numberOfJobs: numberOfJobs)
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.GotEmployerJobs()
            case let .failure(error):
                delegate?.failed(error: error.message)
            }
        }
    }
}
