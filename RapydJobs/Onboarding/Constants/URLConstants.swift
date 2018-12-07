//
//  URLConstants.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 17/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import Foundation

struct URLConstants {
    
    private init () {}
    
    static let shared = URLConstants()
    
    private let scheme = "http://" //http://ec2-18-191-9-134.us-east-2.compute.amazonaws.com/RapydJobs/public/api/
    
    private let host = "ec2-18-191-9-134.us-east-2.compute.amazonaws.com/"
    
    private let path = "RapydJobs/public/api/"
    
    func getBaseURL() -> String {
        return "\(scheme)\(host)\(path)"
    }
    
    func getEndPointURL(_ endPoint: String) -> String {
        let url = getBaseURL()
        return "\(url)\(endPoint)"
    }
    
    func getGooglePlaceSearchURL(with result: String) -> String {
        return "https://maps.googleapis.com/maps/api/geocode/json?address=\(result)&sensor=false&key=\(AppConstants.shared.googleAPIKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}
