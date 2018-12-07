//
//  JobContainer.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 28/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol JobProvider {
    var jobID: Int { get }
    var jobSectors: [String: Bool] { get }
}

protocol JobStorer {
    func save(jobID: Int)
    func save(jobSectors: [String: Bool])
}

final class JobContainer {
    
    private enum Constants {
        static let jobID = "JOB_ID"
        static let jobSectors = "JOB_SECTORS"
    }
    
    let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
}

extension JobContainer: JobProvider {
    var jobSectors: [String : Bool] {
        if (defaults.dictionary(forKey: Constants.jobSectors) != nil) {
            return defaults.dictionary(forKey: Constants.jobSectors) as! [String: Bool]
        } else {
            defaults.set([String: Bool](), forKey: Constants.jobSectors)
            return defaults.dictionary(forKey: Constants.jobSectors) as! [String: Bool]
        }
    }
    
    var jobID: Int {
        // HACK: jobID '0' is returning 404 cause chutiyapa 🤷‍♂️.
        return defaults.integer(forKey: Constants.jobID) < 1 ? 1 : defaults.integer(forKey: Constants.jobID)
    }
}

extension JobContainer: JobStorer {
    func save(jobSectors: [String : Bool]) {
        defaults.set(jobSectors, forKey: Constants.jobSectors)
    }
    
    func save(jobID: Int) {
        defaults.set(jobID, forKey: Constants.jobID)
    }
}
