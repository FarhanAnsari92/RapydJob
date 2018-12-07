//
//  SwipeLikeEmployerService.swift
//  RapydJobs
//
//  Created by Nasir Khan on 17/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol SwipeLikeEmployerDelegate: class {
    func SwipedLikeEmployer()
    func failed(error: String)
}


class SwipeLikeEmployerService {
    
    let network: Network
    weak var delegate: SwipeLikeEmployerDelegate?
    
    init(network: Network = .shared) {
        self.network = network
    }
    
    func like(userID: String, jobID: String, like: String) {
        let request = SwipeLikeEmployerRequest(userID: userID, jobID: jobID, like: like)
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.SwipedLikeEmployer()
            case let .failure(error):
                delegate?.failed(error: error.message)
            }
        }
    }
}
