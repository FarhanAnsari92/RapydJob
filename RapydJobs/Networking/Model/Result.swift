//
//  Result.swift
//  Networking
//
//  Created by Maroof Khan on 07/05/2018.
//  Copyright © 2018 for RapydJobs. All rights reserved.
//

import Foundation

public enum Result<V, E: Error> {
    case success(V)
    case failure(E)
}
