//
//  ProfileDetailModel.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 25/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit

class ProfileDetailModel {
    
    var title: String
    var subtitle: String
    var image: UIImage
    var rating: Double

    var location: String
    var payRate: Int
    var experiences: [ProfileExperienceModel]
    var education: [ProfileExperienceModel]
    var reviews: [ProfileReviewModel]
    var basicInfos = [ProfileBasicInfoModel]()
    
    init(_ title:String, _ subtitle:String, _ imageName:String, _ rating:Double, _ location:String, _ payRate:Int, _ experiences:[ProfileExperienceModel], _ education:[ProfileExperienceModel], _ reviews:[ProfileReviewModel]) {
        self.title = title
        self.subtitle = subtitle
        self.image = UIImage(named: imageName) ?? UIImage()
        self.rating = rating
        self.location = location
        self.payRate = payRate
        self.education = education
        self.experiences = experiences
        self.reviews = reviews
    
        if self.payRate > 0 {
            self.basicInfos.append(ProfileBasicInfoModel("£\(self.payRate) Per Hour", "ic_wallet"))
        }
        self.basicInfos.append(ProfileBasicInfoModel(self.location, "ic_location"))
        self.basicInfos.append(ProfileBasicInfoModel("Download or view CV", "ic_download"))

    }
}

class ProfileBasicInfoModel {
    var text: String
    var image: UIImage
    
    init(_ text: String, _ imageName:String){
        self.text = text
        self.image = UIImage(named: imageName) ?? UIImage()
    }
}

class ProfileExperienceModel {
    var jobTitle: String
    var organisationName: String
    var durationString: String
    
    init(_ jobTitle: String, _ organisationName: String, _ durationString: String) {
        self.jobTitle = jobTitle
        self.organisationName = organisationName
        self.durationString = durationString
    }
}

class ProfileReviewModel {
    var name: String
    var image: UIImage
    var comments: String
    var rating: Double
    
    init(_ name: String, _ imageName:String,_ comments: String, rating: Double) {
        self.name = name
        self.image = UIImage(named: imageName) ?? UIImage()
        self.comments = comments
        self.rating = rating
    }
}
