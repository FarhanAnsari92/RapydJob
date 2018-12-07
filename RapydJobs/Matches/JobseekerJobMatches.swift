//
//  JobseekerJobMatches.swift
//  RapydJobs
//
//  Created by Muhammad Khan on 14/10/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

struct JobseekerJobMatches {
    let currentPage : Int
    let jobMatches : [JobMatches]
    let firstPageUrl : String
    let from : Int
    let lastPage : Int
    let lastPageUrl : String
    let nextPageUrl : String
    let path : String
    let perPage : String
    let prevPageUrl : String
    let to : Int
    let total : Int
}

struct JobMatches {
    let contractLength : String
    let conversationId : String
    let dates : [JobDate]
    let descriptionField : String
    let id : Int
    let jobOwner : JobOwner
    let jobType : String
    let maxSalary : Int
    let minSalary : Int
    let status : String
    let title : String
    let userId : Int
}

struct JobOwner {
    let accountType : String
    let createdAt : String
    let device : String
    let deviceToken : String
    let email : String
    let fcm : String
    let id : Int
    let latitude : String
    let longitude : String
    let organization : Organization
    let passwordToken : String
    let profileImage : String
    let status : String
    let updatedAt : String
    let username : String
}

struct Organization {
    let contact : String
    let createdAt : String
    let id : Int
    let organizationName : String
    let registrationNumber : String
    let updatedAt : String
    let userId : String
    let website : String
}

struct JobDate {
    let day : String
    let endTime : String
    let startTime : String
}
