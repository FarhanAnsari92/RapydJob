//
//  GetEmployerDetailsService.swift
//  RapydJobs
//
//  Created by Nasir Khan on 17/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation


protocol GetEmployerDetailsDelegate: class {
    func GotEmployerDetails()
    func failed(error: String)
}


class GetEmployerDetailsService {
    
    let network: Network
    weak var delegate: GetEmployerDetailsDelegate?
    
    init(network: Network = .shared) {
        self.network = network
    }
    
    func getEmployerDetails(jobID: String) {
        let request = GetEmployerDetailsRequest()
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.GotEmployerDetails()
            case let .failure(error):
                delegate?.failed(error: error.message)
            }
        }
    }
}
