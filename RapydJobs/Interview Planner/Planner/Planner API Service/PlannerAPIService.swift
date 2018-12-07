//
//  PlannerAPIService.swift
//  RapydJobs
//
//  Created by Muhammad Khan on 01/10/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct PlannerAPIService {
    
    private init () {}
    
    static let shared = PlannerAPIService()
    
    func getJobseekerSchedule(completion: @escaping (Error?) -> Void) {
        
        let url = "http://ec2-18-191-9-134.us-east-2.compute.amazonaws.com/RapydJobs/public/api/jobseeker-planner"
        
        let token = AppContainer.shared.user.token
        
        let header = [ "Authorization" :  "Bearer \(token)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                completion(error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    print("Planner Response : ", json)
                } catch {
                    completion(error)
                }
            }
        }
    }
    
    func getJobseekerDateSchedule(day: String, month: String, year: String, completion: @escaping (Error?) -> Void) {
        
        let url = "http://ec2-18-191-9-134.us-east-2.compute.amazonaws.com/RapydJobs/public/api/jobseeker-planner/\(day)?\(month)=\(month)&year=\(year)"
        
        let token = AppContainer.shared.user.token
        
        let header = [ "Authorization" :  "Bearer \(token)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                completion(error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    print("Planner Response : ", json)
                } catch {
                    completion(error)
                }
            }
        }
    }
}
