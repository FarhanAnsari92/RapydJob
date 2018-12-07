//
// JobseekerResponseDTO.swift
//  RapydJobs
//
//  Created by Maroof Khan on 28/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

struct AvailabilityDTO: DTO {
    let day: String
    let startTime: String
    let endTime: String
    
    enum CodingKeys: String, CodingKey {
        case day
        case startTime = "start_time"
        case endTime = "end_time"
    }
}

struct JobseekerDTO: DTO {
    let id: Int?
    let dob: String?
    let description: String?
    let gender: Gender?
    let cv: String?
    let fullname: String?
    let contact: String?
    let minSalary: String?
    let maxSalary: String?
    let dates: [AvailabilityDTO]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case dob
        case description
        case gender
        case cv
        case fullname
        case contact
        case minSalary = "min_sal"
        case maxSalary = "max_sal"
        case dates
    }
}

struct AddressDTO: DTO {
    let id: Int?
    let postalCode: String?
    let address: String?
    let floor: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case postalCode = "postal_code"
        case address
        case floor = "building_floor"
    }
}

struct ExperienceDTO: DTO {
    let id: Int?
    let title: String?
    let company: String?
    let description: String?
    let from: String?
    let to: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case company = "company_name"
        case description
        case from
        case to
    }
}

struct EducationDTO: DTO {
    
    let id: Int
    let title: String
    let institute: String
    let description: String?
    let to: String
    let from: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case institute = "institute_name"
        case description
        case from
        case to
    }
}

struct JobseekerResponseDTO: DTO {
    let id: Int
    let username: String
    let email: String
    let profile_image: String?
    let education: EducationDTO?
    let experience: ExperienceDTO?
    let job_seeker: JobseekerDTO?
    let address: AddressDTO?
}
