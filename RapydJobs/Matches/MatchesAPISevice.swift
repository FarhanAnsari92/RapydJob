//
//  MatchesAPISevice.swift
//  RapydJobs
//
//  Created by Muhammad Khan on 14/10/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct MatchesAPISevice {
    
    private init () {}
    
    static let shared = MatchesAPISevice()
    
    func getJobseekerMatches(limit: String, completion: @escaping (JobseekerJobMatches?, Error?) -> ()) {
        
        let url = URLConstants.shared.getEndPointURL("jobseeker-matches/\(limit)")
        
        guard let token = AppContainer.shared.user.token else {
            return
        }
        
        let header = [  "Authorization" :  "Bearer \(token)",
            "Content-Type": "application/json",
            "Accept" : "application/json" ]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                completion(nil, error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    print("🌎 New Jobseeker Data : ", json)
                    let to = json["to"].intValue
                    let path = json["path"].stringValue
                    let last_page_url = json["last_page_url"].stringValue
                    let prev_page_url = json["prev_page_url"].stringValue
                    let from = json["from"].intValue
                    let total = json["total"].intValue
                    let last_page = json["last_page"].intValue
                    let next_page_url = json["next_page_url"].stringValue
                    let per_page = json["per_page"].stringValue
                    let current_page = json["current_page"].intValue
                    let first_page_url = json["first_page_url"].stringValue
                    
                    let data = json["data"].arrayValue
                    
                    var jobMaches = [JobMatches]()
                    
                    for item in data {
                        let status = item["status"].stringValue
                        let id = item["id"].intValue
                        let conversation_id = item["conversation_id"].stringValue
                        let contract_length = item["contract_length"].stringValue
                        let description = item["description"].stringValue
                        let title = item["title"].stringValue
                        let user_id = item["user_id"].intValue
                        let min_salary = item["min_salary"].intValue
                        let max_salary = item["max_salary"].intValue
                        let job_type = item["job_type"].stringValue
                        
                        let dates = item["dates"].arrayValue
                        
                        var jobDates = [JobDate]()
                        
                        for date in dates {
                            let start_time = date["start_time"].stringValue
                            let end_time = date["end_time"].stringValue
                            let day = date["day"].stringValue
                            
                            let jobDate = JobDate(day: day, endTime: end_time, startTime: start_time)
                            
                            jobDates.append(jobDate)
                        }
                        
                        let job_owner = item["job_owner"]
                        
                        let updated_at = job_owner["updated_at"].stringValue
                        let fcm = job_owner["fcm"].stringValue
                        let email = job_owner["email"].stringValue
                        let profile_image = job_owner["profile_image"].stringValue
                        let device = job_owner["device"].stringValue
                        let username = job_owner["username"].stringValue
                        let latitude = job_owner["latitude"].stringValue
                        let password_token = job_owner["password_token"].stringValue
                        let jobStatus = job_owner["status"].stringValue
                        let jobId = job_owner[""].intValue
                        let account_type = job_owner["account_type"].stringValue
                        let device_token = job_owner["device_token"].stringValue
                        let created_at = job_owner["created_at"].stringValue
                        let longitude = job_owner["longitude"].stringValue
                        
                        let organization = job_owner["organization"]
                        
                        let organization_name = organization["organization_name"].stringValue
                        let registration_number = organization["registration_number"].stringValue
                        let org_updated_at = organization["updated_at"].stringValue
                        let org_id = organization["id"].intValue
                        let website = organization["website"].stringValue
                        let org_created_at = organization["created_at"].stringValue
                        let contact = organization["contact"].stringValue
                        let org_user_id = organization["user_id"].stringValue
                        
                        let org = Organization(contact: contact, createdAt: org_created_at, id: org_id, organizationName: organization_name, registrationNumber: registration_number, updatedAt: org_updated_at, userId: org_user_id, website: website)
                        
                        let jbOwner = JobOwner(accountType: account_type, createdAt: created_at, device: device, deviceToken: device_token, email: email, fcm: fcm, id: jobId, latitude: latitude, longitude: longitude, organization: org, passwordToken: password_token, profileImage: profile_image, status: jobStatus, updatedAt: updated_at, username: username)
                        
                        let jbMatch = JobMatches(contractLength: contract_length, conversationId: conversation_id, dates: jobDates, descriptionField: description, id: id, jobOwner: jbOwner, jobType: job_type, maxSalary: max_salary, minSalary: min_salary, status: status, title: title, userId: user_id)
                        
                        jobMaches.append(jbMatch)
                    }
                    
                    let jobseekerJobMatches = JobseekerJobMatches(currentPage: current_page, jobMatches: jobMaches, firstPageUrl: first_page_url, from: from, lastPage: last_page, lastPageUrl: last_page_url, nextPageUrl: next_page_url, path: path, perPage: per_page, prevPageUrl: prev_page_url, to: to, total: total)
                    
                    completion(jobseekerJobMatches, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }
    }
    
    func getEmployerMatches(jobId: String, limit: String, completion: @escaping (EmployerJobseekerMatches?, Error?) -> ()) {
        
        let url = URLConstants.shared.getEndPointURL("organization-matches")
        
        let token = AppContainer.shared.user.token!
        
        let header = [  "Authorization" :  "Bearer \(token)",
            "Accept" : "application/json" ]
        
        let params: Parameters = [ "job_id" : jobId,
                                   "limit" : limit ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                completion(nil, error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    print("🌎 New Matches Response  : ", json)
                    let data = json["data"]
                    let status = data["status"].stringValue
                    let id = data["id"].intValue
                    let contract_length = data["contract_length"].stringValue
                    let description = data["description"].stringValue
                    let title = data["title"].stringValue
                    let user_id = data["user_id"].intValue
                    let min_salary = data["min_salary"].intValue
                    let max_salary = data["max_salary"].intValue
                    let job_type = data["job_type"].stringValue
                    
                    let dates = data["dates"].arrayValue
                    
                    var jobTimes = [JobTime]()
                    
                    for item in dates {
                        let start_time = item["start_time"].stringValue
                        let end_time = item["end_time"].stringValue
                        let day = item["day"].stringValue
                        
                        let jobTime = JobTime(day: day, endTime: end_time, startTime: start_time)
                        jobTimes.append(jobTime)
                    }
                    
                    let job_matches = data["job_matches"].arrayValue
                    
                    var jobMatches = [JobMatch]()
                    
                    for item in job_matches {
                        let updated_at = item["updated_at"].stringValue
                        let fcm = item["fcm"].stringValue
                        let email = item["email"].stringValue
                        let profile_image = item["profile_image"].stringValue
                        let device = item["device"].stringValue
                        let username = item["username"].stringValue
                        let latitude = item["latitude"].stringValue
                        let password_token = item["password_token"].stringValue
                        let status = item["status"].stringValue
                        let jobseekerId = item["id"].intValue
                        let account_type = item["account_type"].stringValue
                        let created_at = item["created_at"].stringValue
                        let conversation_id = item["conversation_id"].stringValue
                        let device_token = item["device_token"].stringValue
                        let longitude = item["longitude"].stringValue
                        
                        let pvt = item["pivot"]
                        
                        let jobseeker_id = pvt["jobseeker_id"].intValue
                        let pivotId = pvt["id"].intValue
                        let pivot_conversation_id = pvt["conversation_id"].stringValue
                        let job_id = pvt["job_id"].stringValue
                        
                        let pivot = MatchesPivot(conversationId: pivot_conversation_id, id: pivotId, jobId: job_id, jobseekerId: jobseeker_id)
                        
                        let jobMatch = JobMatch(accountType: account_type, conversationId: conversation_id, createdAt: created_at, device: device, deviceToken: device_token, email: email, fcm: fcm, id: jobseekerId, latitude: latitude, longitude: longitude, passwordToken: password_token, pivot: pivot, profileImage: profile_image, status: status, updatedAt: updated_at, username: username)
                        
                        jobMatches.append(jobMatch)
                    }
                    
                    let matches = EmployerJobseekerMatches(contractLength: contract_length, dates: jobTimes, descriptionField: description, id: id, jobMatches: jobMatches, jobType: job_type, maxSalary: max_salary, minSalary: min_salary, status: status, title: title, userId: user_id)
                    
                    completion(matches, nil)
                    
                } catch {
                    completion(nil, error)
                }
            }
        }
    }
}
