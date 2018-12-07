//
//  ProfileDetailsViewModel.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 25/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import Segmentio
import Alamofire
import SwiftyJSON

class DetailsViewModel {
    let segmentData: [SegmentioItem]
    let job: JobModel
    
    init(job: JobModel, shortlist: @escaping () -> Void) {
        self.job = job
        segmentData = ["Details", "Reviews"].map {
            SegmentioItem(title: $0, image: nil)
        }
    }
    
    func numberOfItems(segment: Int) -> Int {
        switch segment {
        case 0: return 2
        case 1: return job.candidates.count
        default: return 0
        }
    }
}

class ProfileDetailsViewModel: NSObject {
    
    var segmentData = [SegmentioItem]()
    
    var data: ProfileDetailModel
    
    override init() {
        
        let experience1 = ProfileExperienceModel("Associate Software Engineer", "ABC Technologies", "March 2014 - September 2016")
        let experience2 = ProfileExperienceModel("Software Engineer", "Davidson Co.", "October 2016 - Present")
        let education1 = ProfileExperienceModel("The Chartered Institute of Management Accountants", "Financial Management", "October 2013 - December 2015")
        let review1 = ProfileReviewModel("John Doe", "face.jpg", "Very good person to work with, nice experience!", rating: 4)
        let review2 = ProfileReviewModel("John Mark", "face.jpg", "It was good working with him! Would work again ", rating: 3)
        let review3 = ProfileReviewModel("John Madison", "face.jpg", "Amazing guy, very cooperative and nice", rating: 4)
        let review4 = ProfileReviewModel("John Hank", "face.jpg", "Finest work I have ever seen", rating: 5)

        data = ProfileDetailModel("John Smith", "Software Engineer @ Davidson Co.", "face.jpg", 4, "London, United Kingdom", 45, [experience1, experience2], [education1], [review1, review2, review3, review4])

        var segmentArray = ["Details", "Reviews"];
        for i in 0..<segmentArray.count {
            segmentData.append(SegmentioItem(
                title: segmentArray[i],
                image: UIImage(named: "")
                )
            )
        }
    }
    
    func numberOfReviews() -> Int {
        return self.data.reviews.count
    }
    
    func numberOfExperiences() -> Int {
        return self.data.experiences.count
    }
    
    func shouldShowExperiencesCard() -> Bool {
        return self.data.experiences.count > 0
    }

    func numberOfSectionsInSegment(_ segment:Int) -> Int {
        if segment == 0 {
            return 3
        } else {
            return 1
        }
    }
    
    func numberOfRowsForSegment(_ segment:Int, andSection section:Int) -> Int {
        if segment == 0 {
            if section == 0 {
                return 3 + 1 // could vary
            } else if section == 1 {
                return self.data.experiences.count + 1
            } else if section == 2 {
                return self.data.education.count + 1
            } else {
                return 0
            }
        } else {
            return 0//self.data.reviews.count
        }
    }
    
    func titleForSection(_ section:Int) -> String {
        switch section {
        case 0:
            return "Basic Information"
        case 1:
            return "Experience Information"
        case 2:
            return "Education"
        default:
            return ""
        }
    }
    
}
