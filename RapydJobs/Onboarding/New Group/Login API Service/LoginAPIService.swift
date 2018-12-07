//
//  LoginAPIService.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 17/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

struct LoginAPIService {
    
    private init () {}
    
    static let shared = LoginAPIService()
    
    func login(_ email: String, _ password: String, completion: @escaping (String?, Error?) -> ()) {
        
        let url = URLConstants.shared.getEndPointURL("oauth/token")
        
        let header = [ "Accept" : "application/json" ]
        
        let params: Parameters = [ "username" : email,
                                   "password" : password,
                                   "grant_type" : "password",
                                   "client_id" : "2",
                                   "client_secret" : "\(AppConstants.shared.clientSecret)"]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: header).response { (response) in
            
            if let error = response.error {
                print("Error : ", error)
                completion(nil, error)
            } else {
                do {
                    print("Printing Response : ", response.response.unsafelyUnwrapped)
                    let statusCode = response.response!.statusCode
                    let json = try JSON(data: response.data!)
                    print("Login Response : ", json)
                    
                    guard let dictionary = json.dictionaryObject else {
                        return
                    }
                    
                    let user: UserResponseModel = Mapper<UserResponseModel>().map(JSON: dictionary)!
                    
                    AppContainer.shared.user.save(user: user)
                    
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
                    
                    if statusCode == 401 {
                        let message = json["message"].stringValue
                        completion(message, nil)
                    } else {
                        completion(nil, nil)
                    }
                } catch {
                    completion(nil, error)
                }
            }
        }
    }
}
