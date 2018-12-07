//
//  GetCardsForEmployerService.swift
//  RapydJobs
//
//  Created by Nasir Khan on 17/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation


protocol GetCardsForEmployerDelegate: class {
    func GotCardsForEmployer()
    func failed(error: String)
}


class GetCardsForEmployerService {
    
    let network: Network
    weak var delegate: GetCardsForEmployerDelegate?
    
    init(network: Network = .shared) {
        self.network = network
    }
    
//    func getCards(jobID: String, apiName: String) {
//        let request = GetCardsForEmployerRequest(jobID: jobID, apiName: apiName)
//        network.request(request) { [weak delegate] result in
//            switch result {
//            case let .success(dto):
//                delegate?.GotCardsForEmployer()
//            case let .failure(error):
//                delegate?.failed(error: error.message)
//            }
//        }
//    }
}
