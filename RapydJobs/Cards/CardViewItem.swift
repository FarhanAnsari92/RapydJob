//
//  CardViewItem.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 24/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit

class CardViewItem {
    
    let jobId: String
    let userId: String
    let id: Int?
    var dates: [JobDatesDTO]?
    var jobSeeker: JobseekerDTO?
//    var educationModel: EducationDTO?
//    var experienceModel: ExperienceDTO?
    
    init() {
        self.title = ""
        self.subtitle = ""
        self.imageName = ""
        self.rating = 0
        self.description = ""
        self.jobTitle = ""
        self.education = ""
        self.location = ""
        self.shouldHide = true
        self.jobId = ""
        self.userId = ""
        self.id = 0
    }
    
    init(dto: JobResponseDTO) {
        self.id = 0
        self.jobId = "\(dto.id)"
        self.userId = ""
        
        self.imageName =  dto.profileImage ?? ""
        self.rating = dto.rating ?? 0.0
        
        self.description = dto.description ?? ""
        
        self.title = dto.title
        self.subtitle = dto.organisationName
        
        self.jobTitle = "£\(dto.minSalary) - £\(dto.maxSalary) Per Hour"
        self.education = "View Shift Timing"
        
        if let location = dto.address {
            self.location = "\(location.address!), \(location.postalCode!)"
        } else {
            self.location = ""
        }
        
        self.dates = dto.dates
    }
    
    init(dto: JobseekerResponseDTO) {
        
        self.userId = dto.job_seeker == nil ? "" : "\(dto.job_seeker!.id!)"
        self.id = dto.id
        self.jobId = ""
        
        self.imageName =  dto.profile_image ?? ""
        self.rating = Double(arc4random_uniform(5) + 1)
        
        self.description = dto.job_seeker?.description ?? ""

        if let jobSeeker = dto.job_seeker {
            self.jobSeeker = jobSeeker
            if let fullname = jobSeeker.fullname {
                self.title = fullname
            } else {
                self.title = ""
            }
        } else {
            self.title = dto.username
        }
        
        if let experience = dto.experience {
            if let title = experience.title, let company = experience.company {
                self.subtitle = "\(title) at \(company)"
                self.jobTitle = "\(title) at \(company)"
            } else {
                self.subtitle = ""
                self.jobTitle = ""
            }
        } else {
            self.subtitle = ""
            self.jobTitle = ""
        }
        
        if let experience = dto.education {
            self.education = "\(experience.title) at \(experience.institute)"
        } else {
            self.education = ""
        }
        
        if let location = dto.address {
            if let address = location.address {
                var loc = address
                if let postalCode = location.postalCode {
                    loc = "\(loc), \(postalCode)"
                }
                self.location = loc
            } else {
                self.location = ""
            }
        } else {
            self.location = ""
        }
    }
    
    var title: String
    var subtitle: String
    var imageName: String
    var rating: Double
    var description: String
    var jobTitle: String
    var education: String
    var location: String
    var shouldHide: Bool = true
    init(_ title:String, _ subtitle:String, _ imageName:String, _ rating:Double, _ description:String, _ jobTitle:String, _ education:String, _ location:String) {
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
        self.rating = rating
        self.description = description
        self.jobTitle = jobTitle
        self.education = education
        self.location = location
        self.jobId = ""
        self.userId = ""
        self.id = 0
    }
}
