//
//  GetJobSeekerDetailsForEmoployerService.swift
//  RapydJobs
//
//  Created by Nasir Khan on 17/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

//protocol GetJobSeekerDetailsForEmoployerDelegate: class {
//    func GotJobSeekerDetailsForEmoployer()
//    func failed(error: String)
//}
//
//
//class GetJobSeekerDetailsForEmoployerService {
//    
//    let network: Network
//    weak var delegate: GetJobSeekerDetailsForEmoployerDelegate?
//    
//    init(network: Network = .shared) {
//        self.network = network
//    }
//    
//    func getJobSeekerDetails(jobSeekerID: String) {
//        let request = GetJobSeekerDetailsForEmoployerRequest(jobSeekerID: jobSeekerID)
//        network.request(request) { [weak delegate] result in
//            switch result {
//            case let .success(dto):
//                delegate?.GotJobSeekerDetailsForEmoployer()
//            case let .failure(error):
//                delegate?.failed(error: error.message)
//            }
//        }
//    }
//}
