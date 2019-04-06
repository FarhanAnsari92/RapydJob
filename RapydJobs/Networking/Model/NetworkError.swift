//
//  NetworkError.swift
//  Networking
//
//  Created by Maroof Khan on 07/05/2018.
//  Copyright © 2018 for RapydJobs. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case requestCreation
    case decoding(Data, Error)
    case server(Error)
    case error(ErrorDTO)
    case unknown(String?)
    case inCompleteProfile(String)
    
    var message: String {
        switch self {
        case .requestCreation:
            return "Request could not be created."
        case .decoding(_, let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .server(let error):
            return error.localizedDescription
        case .unknown(let messages):
            return messages ?? "Oops! Unknown Error Occurred."
//            return "Oops! Unknown Error Occurred."
        case .error(let dto):
            return dto.message
        case .inCompleteProfile(let msg):
            return msg
        }
    }
    
    var title: String {
        switch self {
        case .server:
            return "Rapyd Jobs"
        case .unknown, .decoding, .requestCreation, .inCompleteProfile:
            return "Rapyd Jobs"
        case .error(let dto):
            return dto.error
        }
    }
}
