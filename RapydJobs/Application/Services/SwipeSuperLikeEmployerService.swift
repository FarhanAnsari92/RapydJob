//
//  SwipeSuperLikeEmployerService.swift
//  RapydJobs
//
//  Created by Nasir Khan on 17/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol SwipeSuperLikeEmployerDelegate: class {
    func SwipedSuperLikeEmployer()
    func failed(error: String)
}


class SwipeSuperLikeEmployerService {
    
    let network: Network
    weak var delegate: SwipeSuperLikeEmployerDelegate?
    
    init(network: Network = .shared) {
        self.network = network
    }
    
    func superLike(userID: String, jobID: String) {
        let request = SwipeSuperLikeEmployerRequest(userID: userID, jobID: jobID)
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.SwipedSuperLikeEmployer()
            case let .failure(error):
                delegate?.failed(error: error.message)
            }
        }
    }
}
