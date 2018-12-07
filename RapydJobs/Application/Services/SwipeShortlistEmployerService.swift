//
//  SwipeShortlistEmployerService.swift
//  RapydJobs
//
//  Created by Nasir Khan on 17/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol SwipeShortlistEmployerDelegate: class {
    func SwipedShortlistEmployer()
    func failed(error: String)
}


class SwipeShortlistEmployerService {
    
    let network: Network
    weak var delegate: SwipeShortlistEmployerDelegate?
    
    init(network: Network = .shared) {
        self.network = network
    }
    
    func shortList(userID: String, jobID: String) {
        let request = SwipeShortlistEmployerRequest(userID: userID, jobID: jobID)
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.SwipedShortlistEmployer()
            case let .failure(error):
                delegate?.failed(error: error.message)
            }
        }
    }
}
