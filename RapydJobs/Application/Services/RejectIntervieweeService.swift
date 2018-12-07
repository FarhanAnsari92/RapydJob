//
//  RejectIntervieweeService.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol RejectIntervieweeDelegate: class {
    func RejectedInterviewee()
    func failed(error: String)
}


class RejectIntervieweeService {
    
    let network: Network
    weak var delegate: RejectIntervieweeDelegate?
    
    init(network: Network = .shared) {
        self.network = network
    }
    
    func reject(interviewID: String) {
        let request = RejectIntervieweeRequest(interviewID: interviewID)
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.RejectedInterviewee()
            case let .failure(error):
                delegate?.failed(error: error.message)
            }
        }
    }
}
