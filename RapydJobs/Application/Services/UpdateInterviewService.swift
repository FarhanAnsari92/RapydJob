//
//  UpdateInterviewService.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol UpdateInterviewDelegate: class {
    func UpdatedInterview()
    func failed(error: String)
}


class UpdateInterviewService {
    
    let network: Network
    weak var delegate: UpdateInterviewDelegate?
    
    init(network: Network = .shared) {
        self.network = network
    }
    
    func update(review: String, status: String, interviewID: String) {
        let request = UpdateInterviewRequest(review: review, status: status, interviewID: interviewID)
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.UpdatedInterview()
            case let .failure(error):
                delegate?.failed(error: error.message)
            }
        }
    }
}
