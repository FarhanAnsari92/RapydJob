//
//  NetworkRepository.swift
//  RapydJobs
//
//  Created by Maroof Khan on 26/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol NetworkRepository {
    var userProvider: UserProvider { get }
    var accept: String { get }
    var contentType: String { get }
}

extension NetworkRepository {
    var authorization: String? {
        return userProvider.token
    }
}
