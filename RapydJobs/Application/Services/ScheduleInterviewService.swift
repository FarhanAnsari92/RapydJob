//
//  ScheduleInterviewService.swift
//  RapydJobs
//
//  Created by Nasir Khan on 18/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol ScheduleInterviewDelegate: class {
    func ScheduledInterview()
    func failed(error: String)
}

class ScheduleInterviewService {
    
    let network: Network
    weak var delegate: ScheduleInterviewDelegate?
    
    init(network: Network = .shared) {
        self.network = network
    }
    
    func schedule(userID: String, jobID: String, start: String, end: String, date: String) {
        let request = ScheduleInterviewRequest(userID: userID, jobID: jobID, start: start, end: end, date: date)
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.ScheduledInterview()
            case let .failure(error):
                delegate?.failed(error: error.message)
            }
        }
    }
}
