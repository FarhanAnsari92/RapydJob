//
//  JobseekerSignupAPIService.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 21/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

struct JobseekerSignupAPIService {
    
    private init () {}
    
    static let shared = JobseekerSignupAPIService()
  
    func updateJobseeker(fullName: String, dob: String, description: String, gender: String, contactNo: String, completion: @escaping (Error?) -> Void) {
        
        let accessToken = AppContainer.shared.user.user?.accessToken ?? ""
        
        let url = URLConstants.shared.getEndPointURL("user")
        
        let header = [  "Authorization" : "Bearer \(accessToken)",
                        "Accept" : "application/json",
                        "Content-Type" : "application/json" ]
        var param: Parameters
        if EditProfileFlowManager.shared().isEditProfile {
            param = [ "fullname" : fullName,
                                      "description" : description,
                                      "contact" : contactNo ]
        } else {
            param = [ "fullname" : fullName,
                                      "dob" : dob,
                                      "description" : description,
                                      "gender" : gender.lowercased(),
                                      "contact" : contactNo ]
        }
        
        let params: Parameters = [ "jobseeker" : param ] as [String:Any]
        
        print(params)
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                completion(error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    print(json.dictionaryObject)
                    print("Update Organiation Response : ", json)
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
    }
    
    func updateAddress(schedule: [[String:Any]], address: String, maxSalary: String, minSalary: String, relatedFielfds: [String],distance: String, lat: String, lng: String, completion: @escaping (Error?) -> Void) {
        
        //let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
        let accessToken = AppContainer.shared.user.user?.accessToken ?? ""
        let endPoint = EditProfileFlowManager.shared().isEditProfile ? "work-information" : "user"
        print(endPoint)
        let url = URLConstants.shared.getEndPointURL(endPoint)
        
        let header = [  "Authorization" : "Bearer \(accessToken)",
                        "Accept" : "application/json",
                        "Content-Type" : "application/json" ]
        
        let param1: Parameters = [ "longitude" : lng,
                                   "latitude" : lat,
                                   "distance": distance,
                                   "address" : address ]
        
        let param2: Parameters = [ "max_sal" : maxSalary,
                                   "min_sal" : minSalary ]
        
        let params: Parameters = [ "address" : param1,
                                   "jobseeker" : param2,
                                   "related_fields" : relatedFielfds,
                                   "dates": schedule] as [String:Any] //related_fielfds
        print(params)
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                completion(error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    print(json.dictionaryObject)
                    
                    
                    if let rawObj = json.dictionaryObject {
                        
                        let user = AppContainer.shared.user.user
                        if let addressDic = rawObj["address"] as? [String:Any] {
                            let addressModel: AddressModel = Mapper<AddressModel>().map(JSON: addressDic)!
                            user?.address = addressModel
                        }
                        
                        if let relatedFields = rawObj["related_fields"] as? [[String:Any]] {
                            let relatedFieldsArr: [RelatedField] = Mapper<RelatedField>().mapArray(JSONArray: relatedFields)
                            user?.relatedFields = relatedFieldsArr
                        }
                        
                        if let jobSeeker = rawObj["jobseeker"] as? [String:Any] {
                            let jobSeeker: JobSeekerModel = Mapper<JobSeekerModel>().map(JSON: jobSeeker)!
                            user?.jobSeeker = jobSeeker
                        }
                        print(user?.toJSON())
                        AppContainer.shared.user.save(user: user!)
                    }
                    
                    print("Address Update Response : ", json)
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
    }
    
    func updateExperience(experience: [SignupExperience], completion: @escaping (Error?) -> Void) {
        
        //let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
        let accessToken = AppContainer.shared.user.user?.accessToken ?? ""
        
        let url = URLConstants.shared.getEndPointURL("user")
        
        let header = [  "Authorization" : "Bearer \(accessToken)",
                        "Accept" : "application/json",
                        "Content-Type" : "application/json" ]
        
        var param = [Parameters]()
        
        for item in experience {
            
            let data: Parameters = [ "title" : item.jobTitle,
                                     "company_name" : item.employerName,
                                     "description" : item.description,
                                     "to" : item.to,
                                     "from" : item.from ]
            param.append(data)
        }
        let params: Parameters = [ "experience" : param ]
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                completion(error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    
                    if let rawObj = json.dictionaryObject, let experienceArray = rawObj["experience"] as? [[String:Any]] {
                        let experienceArrayModel = Mapper<ExperienceModel>().mapArray(JSONArray: experienceArray)
                        var user = AppContainer.shared.user.user
                        print(user?.toJSON())
                        user?.experience = experienceArrayModel
                        print(user?.toJSON())
                        AppContainer.shared.user.save(user: user!)
                    }
                    
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
    }
    
    func updateEducation(education: [SignupEducation], completion: @escaping (Error?) -> Void) {
        
        //let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
        let accessToken = AppContainer.shared.user.user?.accessToken ?? ""
        
        let url = URLConstants.shared.getEndPointURL("user")
        
        let header = [  "Authorization" : "Bearer \(accessToken)",
                        "Accept" : "application/json",
                        "Content-Type" : "application/json" ]
        
        var param = [Parameters]()
        
        for item in education {
            
            let data: Parameters = [ "title" : item.educationTitle,
                                     "institute_name" : item.institutionName,
                                     "description" : item.description,
                                     "grade" : item.grade,
                                     "to" : item.to,
                                     "from" : item.from ]
            param.append(data)
        }
        let params: Parameters = [ "education" : param ]
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                completion(error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    
                    if let rawObj = json.dictionaryObject, let educationArray = rawObj["education"] as? [[String:Any]] {
                        let educationArrayModel = Mapper<EducationModel>().mapArray(JSONArray: educationArray)
                        var user = AppContainer.shared.user.user
                        print(user?.toJSON())
                        user?.education = educationArrayModel
                        print(user?.toJSON())
                        AppContainer.shared.user.save(user: user!)
                    }
                    
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
    }
    
    func updateLanguage(language: [SignupLanguage], completion: @escaping (Error?) -> Void) {
        
        //let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
        let accessToken = AppContainer.shared.user.user?.accessToken ?? ""
        
        let url = URLConstants.shared.getEndPointURL("user")
        
        let header = [  "Authorization" : "Bearer \(accessToken)",
                        "Accept" : "application/json",
                        "Content-Type" : "application/json" ]
        
        var param = [Parameters]()
        
        for item in language {
            
            let data: Parameters = [ "language" : item.language,
                                     "level" : item.level ]
            param.append(data)
        }
        let params: Parameters = [ "languages" : param ]
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                completion(error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    
                    if let rawObj = json.dictionaryObject, let languageArray = rawObj["lagnuage"] as? [[String:Any]] {
                        let languageArrayModel = Mapper<LanguageModel>().mapArray(JSONArray: languageArray)
                        var user = AppContainer.shared.user.user
                        print(user?.toJSON())
                        user?.language = languageArrayModel
                        print(user?.toJSON())
                        AppContainer.shared.user.save(user: user!)
                    }
                    
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
    }
    
    func uploadResume(fileData: Data, completion: @escaping (String?, Error?, Double?) -> ()) {
        
        //let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
        let accessToken = AppContainer.shared.user.user?.accessToken ?? ""
        
        let url = URLConstants.shared.getEndPointURL("store-cv")
        
        let header = [  "Authorization" : "Bearer \(accessToken)",
                        "Accept" : "application/json",
                        "Content-Type" : "application/json" ]
        
        let params: Parameters = [ "cv" : "cv.pdf" ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(fileData, withName: "profile_image",fileName: "cv.pdf", mimeType: "application/pdf")
            
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        },
                         to: url,
                         method: .post,
                         headers: header)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    completion(nil, nil,progress.fractionCompleted)
                })
                upload.responseJSON { response in
                    
                    if let error = response.error {
                        completion(nil, error,nil)
                    } else {
                        do {
                            let json = try JSON(response.data!)
                            print("Response : ", json)
                        } catch {
                            completion(nil, error,nil)
                        }
                    }
                }
            case .failure(let encodingError):
                completion(nil, encodingError,nil)
            }
        }
    }
    
    func searchLocation(searchText: String, completion: @escaping (SearchResult?, Error?) -> ()) {
        
        let url = URLConstants.shared.getGooglePlaceSearchURL(with: searchText)
        
        Alamofire.request(url).response { (response) in
            if let error = response.error {
                completion(nil, error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    let results = json["results"].arrayValue
                    
                    if results.count > 0 {
                        let geometry = results[0]["geometry"]
                        let location = geometry["location"]
                        let lat = location["lat"].doubleValue
                        let lng = location["lng"].doubleValue
                        
                        let result = SearchResult(name: searchText, lat: lat, lng: lng)
                        
                        completion(result, nil)
                    }
                } catch {
                    completion(nil, error)
                }
            }
        }
    }
}
