//
//  AppNetworkRepository.swift
//  RapydJobs
//
//  Created by Maroof Khan on 27/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

final class AppNetworkRepository: NetworkRepository {
    let accept: String = "application/json"
    var userProvider: UserProvider {
        return AppContainer.shared.user
    }
    let contentType: String = "application/json"
}
