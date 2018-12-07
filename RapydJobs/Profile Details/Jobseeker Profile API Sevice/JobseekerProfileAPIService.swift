//
//  JobseekerProfileAPIService.swift
//  RapydJobs
//
//  Created by Muhammad Khan on 07/10/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct JobseekerProfileAPIService {
    
    private init () {}
    
    static let shared = JobseekerProfileAPIService()
    
    func getJobseekerPersonalProfile(completion: @escaping (JobseekerModel?, Error?) -> Void) {
        
        let url = URLConstants.shared.getEndPointURL("my-profile-jobseeker")
        
        let token = AppContainer.shared.user.token
        
        let header = [  "Authorization" :  "Bearer \(token)",
                        "Accept" : "application/json" ]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                completion(nil, error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    print("🌎 Personal Profile Response : ", json)
                    let updated_at = json["updated_at"].stringValue
                    let fcm = json["fcm"].stringValue
                    let email = json["email"].stringValue
                    let address = json["address"]
                    let profile_image = json["profile_image"].stringValue
                    let experience = json["experience"].arrayValue
                    let device = json["device"].stringValue
                    let username = json["username"].stringValue
                    let latitude = json["latitude"].stringValue
                    let password_token = json["password_token"].stringValue
                    let status = json["status"].stringValue
                    let id = json["id"].intValue
                    let account_type = json["account_type"].stringValue
                    let device_token = json["device_token"].stringValue
                    let created_at = json["created_at"].stringValue
                    let total_rating = json["total_rating"].intValue
                    let longitude = json["longitude"].stringValue
                    let education = json["education"].arrayValue
                    let new_jobseeker = json["jobseeker"]
                    
                    let cv = new_jobseeker["cv"].stringValue
                    let js_updated_at = new_jobseeker["updated_at"].stringValue
                    let js_description = new_jobseeker["description"].stringValue
                    let min_sal = new_jobseeker["min_sal"].stringValue
                    let gender = new_jobseeker["gender"].stringValue
                    let max_sal = new_jobseeker["max_sal"].stringValue
                    let js_id = new_jobseeker["id"].intValue
                    let js_created_at = new_jobseeker["created_at"].stringValue
                    let contact = new_jobseeker["contact"].stringValue
                    let fullname = new_jobseeker["fullname"].stringValue
                    let dob = new_jobseeker["dob"].stringValue
                    let js_user_id = new_jobseeker["user_id"].stringValue
                    let js_dates = new_jobseeker["dates"].arrayValue
                    
                    var dates = [JobseekerDates]()
                    
                    for dt in js_dates {
                        let start_time = dt["start_time"].stringValue
                        let end_time = dt["end_time"].stringValue
                        let day = dt["day"].stringValue
                        
                        let date = JobseekerDates(day: day, endTime: end_time, startTime: start_time)
                        
                        dates.append(date)
                    }
                    
                    let jsObject = Jobseeker(contact: contact, createdAt: js_created_at, cv: cv, dates: dates, descriptionField: js_description, dob: dob, fullname: fullname, gender: gender, id: js_id, maxSal: max_sal, minSal: min_sal, updatedAt: js_updated_at, userId: js_user_id)
                    
                    let lat = address["latitude"].stringValue
                    let updatedAt = address["updated_at"].stringValue
                    let addressId = address["id"].intValue
                    let newAddress = address["address"].stringValue
                    let createdAt = address["created_at"].stringValue
                    let distance = address["distance"].stringValue
                    let user_id = address["user_id"].intValue
                    let lng = address["longitude"].stringValue
                    let building_floor = address["building_floor"].stringValue
                    let postal_code = address["postal_code"].stringValue
                    
                    var jobseekerExperience = [JobseekerExperience]()
                    var jobseekerEducation = [JobseekerEducation]()
                    
                    for exp in experience {
                        let exp_updated_at = exp["updated_at"].stringValue
                        let exp_created_at = exp["created_at"].stringValue
                        let exp_id = exp["id"].intValue
                        let exp_user_id = exp["user_id"].intValue
                        let company_name = exp["company_name"].stringValue
                        let from = exp["from"].stringValue
                        let title = exp["title"].stringValue
                        let description = exp["description"].stringValue
                        let to = exp["to"].stringValue
                        
                        let jobseekerExp = JobseekerExperience(companyName: company_name, createdAt: exp_created_at, descriptionField: description, from: from, id: exp_id, title: title, to: to, updatedAt: exp_updated_at, userId: exp_user_id)
                        
                        jobseekerExperience.append(jobseekerExp)
                    }
                    
                    for edu in education {
                        let edu_updated_at = edu["updated_at"].stringValue
                        let edu_created_at = edu["created_at"].stringValue
                        let edu_id = edu["id"].intValue
                        let edu_user_id = edu["user_id"].intValue
                        let institute_name = edu["institute_name"].stringValue
                        let from = edu["from"].stringValue
                        let title = edu["title"].stringValue
                        let description = edu["description"].stringValue
                        let to = edu["to"].stringValue
                        
                        let jobseekerEdu = JobseekerEducation(createdAt: edu_created_at, descriptionField: description, from: from, id: edu_id, instituteName: institute_name, title: title, to: to, updatedAt: edu_updated_at, userId: edu_user_id)
                        
                        jobseekerEducation.append(jobseekerEdu)
                    }
                    
                    let jobssekerAddress = Addres(address: newAddress, buildingFloor: building_floor, createdAt: createdAt, distance: distance, id: addressId, latitude: lat, longitude: lng, postalCode: postal_code, updatedAt: updatedAt, userId: user_id)
                    
                    let jobseeker = JobseekerModel(id: id, updatedAt: updated_at, accountType: account_type, address: jobssekerAddress, createdAt: created_at, device: device, deviceToken: device_token, education: jobseekerEducation, email: email, experience: jobseekerExperience, fcm: fcm, latitude: latitude, longitude: longitude, passwordToken: password_token, profileImage: profile_image, status: status, totalRating: total_rating, username: username, jobseeker: jsObject)
                    
                    completion(jobseeker, nil)
                    
                } catch {
                    completion(nil, error)
                }
            }
        }
    }
}
