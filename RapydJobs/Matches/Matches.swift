//
//  Matches.swift
//  RapydJobs
//
//  Created by Muhammad Khan on 14/10/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

struct EmployerMatches {
    let contractLength: String
    let dates: [JobTime]
    let descriptionField: String
    let id: Int
    let jobMatches: [JobMatch]
    let jobType: String
    let maxSalary: Int
    let minSalary: Int
    let status: String
    let title: String
    let userId: Int
}

struct JobMatch {
    let accountType: String
    let conversationId: String
    let createdAt: String
    let device: String
    let deviceToken: String
    let email: String
    let fcm: String
    let id: Int
    let latitude: String
    let longitude: String
    let passwordToken: String
    let pivot: MatchesPivot
    let profileImage: String
    let status: String
    let updatedAt: String
    let username: String
}

struct MatchesPivot {
    let conversationId: String
    let id: Int
    let jobId: String
    let jobseekerId: Int
}

struct JobTime {
    let day: String
    let endTime: String
    let startTime: String
}
