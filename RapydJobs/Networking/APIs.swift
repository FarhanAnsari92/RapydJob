//
//  APIs.swift
//  Networking
//
//  Created by Maroof Khan on 07/05/2018.
//  Copyright © 2018 For MyTaxi. All rights reserved.
//

import Foundation

extension API {
    static let rapydPublic: API = .init(baseURL: .init(scheme: "http", host: "ec2-18-191-9-134.us-east-2.compute.amazonaws.com"), path: ["RapydJobs", "public"], requestModifiers: [GenericAPIRequestModifier()])
    
    static var rapydPrivate: API = .init(baseURL: .init(scheme: "http", host: "ec2-18-191-9-134.us-east-2.compute.amazonaws.com"), path: ["RapydJobs", "public"], requestModifiers: [GenericAPIRequestModifier(), PrivateAPIRequestModifier()])

    func getBaseURLForImage(_ imageName: String) -> URL {
        var str = "\(self.baseURL.scheme)://\(self.baseURL.host)/"
        for currentPath in path {
            str.append("\(currentPath)/")
        }
        //str.append("api/user-image/\(imageName)")
        str.append("api/files/\(imageName)")
        return URL(string: str)!
    }
    
    func getBaseURLForChatImage(_ imageName: String) -> URL {
        var str = "\(self.baseURL.scheme)://\(self.baseURL.host)/"
        for currentPath in path {
            str.append("\(currentPath)/")
        }
        str.append("api/getMessageFile/\(imageName)")
        return URL(string: str)!
    }
}
