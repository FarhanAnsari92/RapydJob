//
//  SignupUpdateEmployerService.swift
//  RapydJobs
//
//  Created by Nasir Khan on 17/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation



protocol SignupUpdateEmployerDelegate: class {
    func SignedupUpdateEmployer()
    func failed(error: String)
}


class SignupUpdateEmployerService {
    
    let network: Network
    weak var delegate: SignupUpdateEmployerDelegate?
    
    init(network: Network = .shared) {
        self.network = network
    }
    
//    func update(profileImage:String, floor: String, postal: String, address: String, name: String, description: String, website: String, regNumber: String) {
//        let request = SignupUpdateEmployerRequest(profileImage:profileImage, floor: floor, postal: postal, address: address, name: name, description: description, website: website, regNumber: regNumber)
//        network.request(request) { [weak delegate] result in
//            switch result {
//            case let .success(dto):
//                delegate?.SignedupUpdateEmployer()
//            case let .failure(error):
//                delegate?.failed(error: error.message)
//            }
//        }
//    }
}
