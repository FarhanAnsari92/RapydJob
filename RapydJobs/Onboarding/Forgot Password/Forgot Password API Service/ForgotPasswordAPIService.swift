//
//  ForgotPasswordAPIService.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 17/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct ForgotPasswordAPIService {
    
    private init () {}
    
    static let shared = ForgotPasswordAPIService()
    
    func resetPassword(_ email: String, completion: @escaping (String?, Error?) -> ()) {
        
        let url = URLConstants.shared.getEndPointURL("reset-password")
        
        let header = [ "Accept" : "application/json" ]
        
        let params: Parameters = [ "email" : email ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                completion(nil, error)
            } else {
                do {
                    let statusCode = response.response!.statusCode
                    let json = try JSON(data: response.data!)
                    print("Reset Password Response : ", json)
                    
                    if statusCode == 302 {
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
