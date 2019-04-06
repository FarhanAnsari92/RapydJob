//
//  JobResponseDTO.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 29/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

import Foundation

struct JobDatesDTO: DTO {
    let day: String?
    let startTime: String?
    let endTime: String?
    
    enum CodingKeys: String, CodingKey {
        case day = "day"
        case startTime = "start_time"
        case endTime = "end_time"
    }
}
    
struct JobAddressDTO: DTO {
    let id: Int?
    let userID: Int?
    let postalCode: String?
    let address: String?
    let floor: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case postalCode = "postal_code"
        case address
        case floor = "building_floor"
    }
}

struct JobResponseDTO: DTO {
    let id: Int
    let userID: Int
    let title: String
    let description: String?
    let minSalary: Int
    let maxSalary: Int
    let jobType: String
    let contractLength: String
    let status: String
    let organisationName: String
    let profileImage: String?
    let address: JobAddressDTO?
    let dates: [JobDatesDTO]?
    let education: [EducationDTO]?
    let experience: [ExperienceDTO]?
    let rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userID = "user_id"
        case title
        case description
        case minSalary = "min_salary"
        case maxSalary = "max_salary"
        case jobType = "job_type"
        case contractLength = "contract_length"
        case status
        case organisationName = "organization_name"
        case profileImage = "profile_image"
        case address
        case dates = "dates"
        case rating = "rating"
        case education = "education"
        case experience = "experience"
    }
}
