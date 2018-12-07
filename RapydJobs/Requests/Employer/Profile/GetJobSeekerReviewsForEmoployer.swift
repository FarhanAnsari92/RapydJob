//
//  GetJobSeekerReviewsForEmoployer.swift
//  RapydJobs
//
//  Created by Nasir Khan on 13/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class GetJobSeekerReviewsForEmoployerRequest: EndpointProvider {
    typealias Response = GetJobSeekerReviewsForEmoployerResponse
    
    private let jobSeekerID: String
    private let numberOfReviews : String
    
    var endpoint: Endpoint {
        
        return Endpoint(api: .rapydPrivate, method: .get, path: ["api", "review", jobSeekerID, numberOfReviews], body: nil)
        
    }
    
    init(jobSeekerID: String, numberOfReviews: String) {
        self.jobSeekerID = jobSeekerID
        self.numberOfReviews = numberOfReviews
    }
    
}

struct GetJobSeekerReviewsForEmoployerResponse: DTO {
    
//    let education : Array<Review>
    
}


class Review: Encodable, Decodable {
    
//    let name: String
//    let profileImage: String
//    let review: String
//    let rating: Int
    
    
}
