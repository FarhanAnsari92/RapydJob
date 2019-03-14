//
//  CreateJobAPIService.swift
//  RapydJobs
//
//  Created by Muhammad Khan on 16/10/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct CreateJobAPIService {
    
    private init () {}
    
    static let shared = CreateJobAPIService()
    
    func create(schedule: [[String:Any]], title: String, description: String, minSalary: String, maxSalary: String, jobType: String, contractLength: String, relatedFields: [String], completion: @escaping (Error?, Bool) -> ()) {
        
        let url = URLConstants.shared.getEndPointURL("store-job")
        
        let token = AppContainer.shared.user.token
        print(token!)
        
        let header = [  "Authorization" :  "Bearer \(token!)",
                        "Accept" : "application/json" ]
        
        let params: Parameters = [ "title"              : title,
                                   "description"        : description,
                                   "min_salary"         : minSalary,
                                   "max_salary"         : maxSalary,
                                   "job_type"           : jobType.lowercased(),
                                   "contract_length"    : contractLength.lowercased(),
                                   "related_fields"     : relatedFields,
                                   "dates"              : schedule ] as [String : Any]
        print(params)
        print(header)
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                completion(error, true)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    print("Job Post Response : ", json)
                    if response.response?.statusCode == 401 {
                        completion(nil, true)
                    } else {
                        completion(nil, false)
                    }
                    
                } catch {
                    completion(error, true)
                }
            }
        }
    }
}
