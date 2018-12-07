//
//  InitialSignUpAPIService.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 17/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

struct InitialSignUpAPIService {
    
    private init () {}
    
    static let shared = InitialSignUpAPIService()
    
    func initialSignup(_ username: String, _ email: String, _ password: String, _ accountType: String, completion
        : @escaping (String?, Error?) -> ()) {
        
        let url = URLConstants.shared.getEndPointURL("user")
        print("🌎 URL : ", url)
        let header = [ "Accept" : "application/json",
                       "Content-Type" : "application/json" ]
        print("🌎 Header : ", header)
        let params: Parameters = [ "username"       : username.replacingOccurrences(of: " ", with: ""),
                                   "email"          : email,
                                   "password"       : password,
                                   "c_password"     : password,
                                   "account_type"   : accountType.lowercased(),
            "fcm": (UIApplication.shared.delegate as! AppDelegate).apnsToken]
        print("🌎 Params : ", params)
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                completion(nil, error)
            } else {
                do {
                    print("Printing Response : ", response.response.unsafelyUnwrapped)
                    let statusCode = response.response!.statusCode
                    let json = try JSON(data: response.data!)
                    
                    let dictionary = json.dictionaryObject
                    print(dictionary!)
                    let user: UserResponseModel = Mapper<UserResponseModel>().map(JSON: dictionary!)!
                    print(user.toJSON())
                    AppContainer.shared.user.save(user: user)
                    
                    print("Initial Signup Response : ", json)
                    let token = json["access_token"].stringValue
                    UserDefaults.standard.set(token, forKey: "accessToken")
                    UserDefaults.standard.synchronize()
                    
                    let account_type = json["account_type"].stringValue
                    let username = json["username"].stringValue
                    let access_token = json["access_token"].stringValue
                    let email = json["email"].stringValue
                    let profile_image = json["profile_image"].stringValue
                    let id = json["id"].stringValue
                    
                    AppContainer.shared.user.save(email: email)
                    AppContainer.shared.user.save(token: access_token)
                    AppContainer.shared.user.save(userId: id)
                    AppContainer.shared.user.save(profileImage: profile_image)
                    AppContainer.shared.user.save(accountType: account_type)
                    AppContainer.shared.user.save(username: username)
                    
                    if statusCode == 422 {
                        _ = json["message"].stringValue
                        let errors = json["errors"]
                        let username = errors["username"].arrayValue
                        let email = errors["email"].arrayValue
                        var message = ""
                        
                        for name in username {
                            message.append(" \(name)")
                        }
                        for name in email {
                            message.append(" \(name)")
                        }
                        completion(message, nil)
                    } else {
                        completion(nil, nil)
                    }
                } catch {
                    print("🔥 Catch Error : ", error)
                    completion(nil, error)
                }
            }
        }
    }
}
