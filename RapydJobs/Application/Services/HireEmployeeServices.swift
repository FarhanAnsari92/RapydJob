//
//  HireEmployeeServices.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol HireEmployeeDelegate: class {
    func HiredEmployee()
    func failed(error: String)
}


class HireEmployeeService {
    
    let network: Network
    weak var delegate: HireEmployeeDelegate?
    
    init(network: Network = .shared) {
        self.network = network
    }
    
    func hire(jobID: String, jobSeekerID: String) {
        let request = HireEmployeeRequest(jobID: jobID, jobSeekerID: jobSeekerID)
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.HiredEmployee()
            case let .failure(error):
                delegate?.failed(error: error.message)
            }
        }
    }
}
