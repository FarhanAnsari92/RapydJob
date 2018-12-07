//
//  UserResponseModel.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 10/26/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

class UserResponseModel: Mappable {
    
    var userName: String?
    var email: String?
    var userId: Int?
    var accountType: String?
    var deviceToken: String?
    var profileImage: String?
    var fcm: String?
    var accessToken: String?
    var totalRating: Double?
    var jobSeeker: JobSeekerModel?
    var address: AddressModel?
    var organization: OrganizationModel?
    var relatedFields: [RelatedField]?
    var education: [EducationModel]?
    var language: [LanguageModel]?
    var experience: [ExperienceModel]?
    
    init() { }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        userName      <- map["username"]
        email         <- map["email"]
        userId        <- map["id"]
        accountType   <- map["account_type"]
        deviceToken   <- map["device_token"]
        profileImage  <- map["profile_image"]
        fcm           <- map["fcm"]
        totalRating   <- map["total_rating"]
        jobSeeker     <- map["jobseeker"]
        address       <- map["address"]
        organization  <- map["organization"]
        accessToken   <- map["access_token"]
        relatedFields <- map["related_fields"]
        education     <- map["education"]
        language      <- map["language"]
        experience    <- map["experience"]
    }
    
    required public init(coder aDecoder: NSCoder) {
    }
    
}
