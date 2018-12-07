//
//  GetIntervieweesService.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol GetIntervieweesDelegate: class {
    func GotInterviewees()
    func failed(error: String)
}


class GetIntervieweesService {
    
    let network: Network
    weak var delegate: GetIntervieweesDelegate?
    
    init(network: Network = .shared) {
        self.network = network
    }
    
    func getInterviewees(status: String) {
        let request = GetIntervieweesRequest(status: status)
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.GotInterviewees()
            case let .failure(error):
                delegate?.failed(error: error.message)
            }
        }
    }
}
