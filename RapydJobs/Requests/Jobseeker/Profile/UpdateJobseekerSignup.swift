//
//  UpdateEmployerSignup.swift
//  RapydJobs
//
//  Created by Nasir Khan on 12/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class UpdateJobseekerSignupRequest: EndpointProvider {
    typealias Response = UpdateJobseekerSignupResponse
    
    private let profileImage: String?
    private let resume: String
    
    private let fullName: String
    private let dob: String
    private let contact: String
    private let gender: String
    private let description: String
    private let maxSalary: String
    private let minSalary: String
    private let address: String
    
    private let relatedFields: Array<String>
    private let educations: Array<Any>
    private let experience: Array<Any>
    private let language: Array<Any>
    
    var endpoint: Endpoint {
        
        let dictionary = [
            "user_profile_image": [ "profile_image":profileImage ],
            "address": [ "address":address ],
            "jobseeker_cv": [ "cv":resume ],
            "related_fields": relatedFields,
            "education":educations,
            "experience":experience,
            "languages":language,
            "jobseeker": [
                "fullname":fullName,
                "dob":dob,
                "contact":contact,
                "gender":gender,
                "description":description,
                "max_sal":maxSalary,
                "min_sal":minSalary
            ]
            ] as [String : Any]
        
        let body = try? JSONSerialization.data( withJSONObject: dictionary, options: [])
        
        return Endpoint(api: .rapydPrivate, method: .put, path: ["api", "user"], body: body)
        
    }
    
    init(profileImage:String?, resume: String, fullName: String, dob: String, contact: String, gender: String, description: String, maxSalary: String, minSalary: String, address: String, relatedFields: Array<String>, educations: Array<Any>, experience: Array<Any>, language: Array<Any>) {
        self.profileImage = profileImage
        self.resume = resume
        self.fullName = fullName
        self.dob = dob
        self.contact = contact
        self.gender = gender
        self.description = description
        self.maxSalary = maxSalary
        self.minSalary = minSalary
        self.address = address
        
        self.relatedFields = relatedFields
        self.educations = educations
        self.experience = experience
        self.language = language
        
    }
}

struct UpdateJobseekerSignupResponse: DTO {
    
}


//class Education: Encodable, Decodable {
//
//    let title: String
//    let institute: String
//    let description: String
//    let to: String
//    let from: String
//
//
//    init(title: String, institute: String, description: String, to: String, from: String) {
//
//        self.title = title
//        self.institute = institute
//        self.description = description
//        self.to = to
//        self.from = from
//
//    }
//
//    func toDict() -> Dictionary<String, String> {
//        var dict = Dictionary<String, String>()
//        dict["title"] = self.title
//        dict["institute_name"] = self.institute
//        dict["description"] = self.description
//        dict["to"] = self.to
//        dict["from"] = self.from
//        return dict
//    }
//
//}


//class Experience: Encodable, Decodable {
//    
//    let title: String
//    let company: String
//    let description: String
//    let to: String
//    let from: String
//    
//    
//    init(title: String, company: String, description: String, to: String, from: String) {
//        
//        self.title = title
//        self.company = company
//        self.description = description
//        self.to = to
//        self.from = from
//        
//    }
//    
//    func toDict() -> Dictionary<String, String> {
//        var dict = Dictionary<String, String>()
//        dict["title"] = self.title
//        dict["company_name"] = self.company
//        dict["description"] = self.description
//        dict["to"] = self.to
//        dict["from"] = self.from
//        return dict
//    }
//    
//}

//class Language: Encodable, Decodable {
//
//    let language: String
//    let level: String
//
//
//    init(language: String, level: String) {
//
//        self.language = language
//        self.level = level
//
//    }
//
//    func toDict() -> Dictionary<String, String> {
//        var dict = Dictionary<String, String>()
//        dict["language"] = self.language
//        dict["level"] = self.level
//        return dict
//    }
//
//}

