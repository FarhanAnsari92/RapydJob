////
////  GetCardsForEmployer.swift
////  RapydJobs
////
////  Created by Nasir Khan on 13/07/2018.
////  Copyright © 2018 chymps. All rights reserved.
////
//
//import Foundation
//
//class GetCardsForEmployerRequest: EndpointProvider {
//    typealias Response = GetCardsForEmployerResponse
//    
//    private let jobID: String
//    private let apiName: String
//    
//    // show-filtered-users
//    // show-shortlisted-jobseekers
//    
//    var endpoint: Endpoint {
//        return Endpoint(api: .rapydPrivate, method: .get, path: ["api", apiName, jobID], body: nil)
//    }
//    
//    init(jobID: String, apiName: String) {
//        self.jobID = jobID
//        self.apiName = apiName
//    }
//    
//}
//
//struct GetCardsForEmployerResponse: DTO {
//    
////    let jobs : Array<Card>
//    
//}
//
//
//class Card : Decodable, Encodable {
//    
////    let name : String
////    let title : String
////    let organization : String
////    let rating : Int
////    let description : String
////    let education : String
////    let address : String
////    let availability : Array<Availability>
//
//}


//class Availability : Decodable, Encodable {
//
////    let day: String
////    let Start: String
////    let end: String
//
//}


