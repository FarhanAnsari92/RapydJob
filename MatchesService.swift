//
//  MatchesService.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 28/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol MatchesDelegate: class {
    func EmployersMatched(_ matches: EmployerMatchesResponse)
    func JobSeekersMatched(_ matches: JobSeekerMatchesResponse)
    func failed(error: String)
}


class MatchesService {
    
    let network: Network
    weak var delegate: MatchesDelegate?
    
    init(network: Network = .shared) {
        self.network = network
    }
    
    func getEmployerMatches(limit: String) {
        let jobIDString = "\(AppContainer.shared.job.jobID)"
        let request = EmployerMatchesRequest(jobID: jobIDString , limit: limit)
        network.request(request) { [weak delegate] result in
            print("🌎 🔥 Old Matches Response : ", result)
            switch result {
            case let .success(dto):
                delegate?.EmployersMatched(dto)
            case let .failure(error):
                delegate?.failed(error: error.message)
            }
        }
    }
    
    func getJobSeekerMatches(jobID: String, limit: String) {
        let request = JobSeekerMatchesRequest(limit: limit)
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.JobSeekersMatched(dto)
            case let .failure(error):
                delegate?.failed(error: error.message)
            }
        }
    }

}
