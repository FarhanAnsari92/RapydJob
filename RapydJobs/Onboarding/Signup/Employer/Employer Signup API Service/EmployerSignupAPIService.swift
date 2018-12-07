//
//  EmployerSignupAPIService.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 20/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

struct EmployerSignupAPIService {
    
    private init () {}
    
    static let shared = EmployerSignupAPIService()
    
    func updateEmployer(organizationName: String, website: String, registrationNo: String, contactNo: String, completion: @escaping (Error?) -> Void) {
                
        //let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
        let accessToken = AppContainer.shared.user.user?.accessToken ?? ""
        
        let url = URLConstants.shared.getEndPointURL("user")
        print("URL : ", url)
        let header = [  "Authorization" : "Bearer \(accessToken)",
                        "Accept" : "application/json",
                        "Content-Type" : "application/json" ]
        print("Header : ", header)
        let param: Parameters = [ "organization_name" : organizationName,
                                   //"description" : "Description is not part of the design, interestingly.",
                                   "website" : website,
                                   "registration_number" : registrationNo,
                                   "contact" : contactNo ]
        
        let params: Parameters = [ "organization" : param ]
        print("Params : ", params)
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                completion(error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    print("Update Organiation Response : ", json)
                    guard let userDic = json.dictionaryObject else {
                        return
                    }
                    
                    let orgDict = userDic["organization"] as! [String:Any]
                    let orgModel = Mapper<OrganizationModel>().map(JSON: orgDict)
                    
                    let user = AppContainer.shared.user.user
                    user?.organization = orgModel
                    print(user?.toJSON())
                    AppContainer.shared.user.save(user: user!)
                    
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
    }
    
    func sendSMS(contactNumber: String, completion: @escaping (Error?) -> Void) {
        
        //let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
        let accessToken = AppContainer.shared.user.user?.accessToken ?? ""
        
        let url = URLConstants.shared.getEndPointURL("send-sms")
        
        let header = [  "Authorization" : "Bearer \(accessToken)",
                        "Accept" : "application/json",
                        "Content-Type" : "application/json" ]
        
        let params: Parameters = [ "contact_number" : contactNumber ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                completion(error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    print("Code Resend Response : ", json)
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
    }
    
    func verifyUser(in vc: UIViewController, code: String, completion: @escaping (Error?) -> Void) {
        
        //let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
        let accessToken = AppContainer.shared.user.user?.accessToken ?? ""
        
        let url = URLConstants.shared.getEndPointURL("verify-user")
        
        let header = [  "Authorization" : "Bearer \(accessToken)",
                        "Accept" : "application/json" ]
        
        let params: Parameters = [ "code" : code ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                completion(error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    print("Verify User Response : ", json)
                    let message = json["message"].stringValue
                    if message == "verified" {
                        completion(nil)
                    } else {
                        AlertService.shared.alert(in: vc, "Wrong code please try again with correct code or try resending the code")
                    }
                } catch {
                    completion(error)
                }
            }
        }
    }
    
    func updateAddress(address: String, floor: String, postCode: String, distance: String, lat: String, lng: String, completion: @escaping (Error?) -> Void) {
        
        //let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
        let accessToken = AppContainer.shared.user.user?.accessToken ?? ""
        
        let url = URLConstants.shared.getEndPointURL("user")
        
        let header = [  "Authorization" : "Bearer \(accessToken)",
                        "Accept" : "application/json",
                        "Content-Type" : "application/json" ]
        
        let param: Parameters = [ "longitude" : lng,
                                  "latitude" : lat,
                                  "building_floor" : floor,
                                  "postal_code" : postCode,
                                  "address" : address,
                                  "distance": distance]
        
        let params: Parameters = ["address":param]
        print(params)
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                completion(error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    print("Address Update Response : ", json)
                    guard let rawObj = json.dictionaryObject else {
                        return
                    }
                    
                    let user = AppContainer.shared.user.user
                    if let addressDic = rawObj["address"] as? [String:Any] {
                        let addressModel: AddressModel = Mapper<AddressModel>().map(JSON: addressDic)!
                        user?.address = addressModel
                        AppContainer.shared.user.save(user: user!)
                    }
                    
                    
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
    }
    
    //func uploadPicture(image: UIImage, completion: @escaping (String?, Error?) -> ()) {
    func uploadPicture(image: UIImage, completion: @escaping (String?, Error?, Double?) -> ()) {
        //let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
        let accessToken = AppContainer.shared.user.user?.accessToken ?? ""
        
        let imageData = UIImageJPEGRepresentation(image, 0.6)!
        
        let url = URLConstants.shared.getEndPointURL("store-profileimage")
        
        let header = [  "Authorization" : "Bearer \(accessToken)",
                        "Accept" : "application/json",
                        "Content-Type" : "application/json" ]
        
        let params: Parameters = [ "profile_image" : "abc.jpg" ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "profile_image",fileName: "abc.jpg", mimeType: "image/jpeg")
            
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
                    print("Upload Progress: \(progress.fractionCompleted)")
                    completion(nil, nil,progress.fractionCompleted)
                })
                
                upload.responseJSON { response in
                    
                    if let error = response.error {
                        completion(nil, error,nil)
                    } else {
                        do {
                            let json = try JSON(response.data!)
                            print("Response : ", json)
                            let imageName = json["profile_image"].stringValue
                            let profile_image = json["profile_image"].stringValue
                            AppContainer.shared.user.save(profileImage: profile_image)
                            
                            let user = AppContainer.shared.user.user
                            user?.profileImage = json["profile_image"].stringValue
                            AppContainer.shared.user.save(user: user!)
                            
                            completion(imageName, nil,nil)
                        } catch {
                            completion(nil, error,nil)
                        }
                    }
                }
            case .failure(let encodingError):
                completion(nil, encodingError, nil)
            }
        }
    }
    
    func updateImage(imageName: String, completion: @escaping (Error?) -> ()) {
        
        let url = URLConstants.shared.getEndPointURL("user")
        
        //let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
        let accessToken = AppContainer.shared.user.user?.accessToken ?? ""
        
        let header = [  "Authorization" : "Bearer \(accessToken)",
                        "Accept" : "application/json",
                        "Content-Type" : "application/json" ]
        
        let param: Parameters = [ "profile_image" : imageName ]
        
        let params: Parameters = [ "user_profile_image" : param ]
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                completion(error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    print("Address Update Response : ", json)
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
    }
}
