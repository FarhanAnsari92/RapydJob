//
//  GetJobSeekerReviewsForEmoployerService.swift
//  RapydJobs
//
//  Created by Nasir Khan on 17/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation


protocol GetJobSeekerReviewsForEmoployerDelegate: class {
    func GotJobSeekerReviewsForEmoployer()
    func failed(error: String)
}


class GetJobSeekerReviewsForEmoployerService {
    
    let network: Network
    weak var delegate: GetJobSeekerReviewsForEmoployerDelegate?
    
    init(network: Network = .shared) {
        self.network = network
    }
    
    func getReviews(jobSeekerID: String, numberOfReviews: String) {
        let request = GetJobSeekerReviewsForEmoployerRequest(jobSeekerID: jobSeekerID, numberOfReviews: numberOfReviews)
        network.request(request) { [weak delegate] result in
            switch result {
            case let .success(dto):
                delegate?.GotJobSeekerReviewsForEmoployer()
            case let .failure(error):
                delegate?.failed(error: error.message)
            }
        }
    }
}
