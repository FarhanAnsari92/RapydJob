//
//  UserContainer.swift
//  RapydJobs
//
//  Created by Maroof Khan on 27/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ObjectMapper

enum AccountType: String {
    case jobSeeker = "jobseeker"
    case employer = "organization"
}

protocol UserProvider {
    var token: String? { get }
    var username: String { get }
    var email: String { get }
    var accountType: AccountType { get }
    var profileImage: String { get }
    var userId: String { get }
    var isLogin: Bool { get }
}

protocol UserStorer {
    func save(token: String)
    func removeToken()
    func save(username: String)
    func save(email: String)
    func save(accountType: String)
    func save(profileImage: String?)
    func save(userId: String)
    func save(isLogin: Bool)
}
 
final class UserContainer {
    
    private enum Constants {
        static let token = "USER_TOKEN"
        static let username = "USER_NAME"
        static let email = "USER_EMAIL"
        static let accountType = "USER_ACCOUNTTYPE"
        static let profileImage = "USER_PROFILEIMAGE"
        static let userId = "USER_ID"
        static let user = "APP_USER"
        static let isLogin = "IS_LOGIN"
    }
    
    let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
}

extension UserContainer: UserProvider {
    var isLogin: Bool {
        return defaults.bool(forKey: Constants.isLogin) 
    }
    
    var username: String {
        return defaults.string(forKey: Constants.username) ?? ""
    }
    
    var email: String {
        return defaults.string(forKey: Constants.email) ?? ""
    }
    
    var accountType: AccountType {
        let type = defaults.string(forKey: Constants.accountType) ?? ""
        if type == AccountType.employer.rawValue {
            return .employer
        } else {
            return .jobSeeker
        }
    }
    
    var userId: String {
        return defaults.string(forKey: Constants.userId) ?? ""
    }
    
    var profileImage: String {
        return defaults.string(forKey: Constants.profileImage) ?? ""
    }
    
    var token: String? {
        return defaults.string(forKey: Constants.token)
    }
    
    var user: UserResponseModel? {
        guard let user = defaults.string(forKey: Constants.user) else {
            return nil
        }
        guard let userObj = Mapper<UserResponseModel>().map(JSONString: user) else {
            return nil
        }
        return userObj
    }
}

extension UserContainer: UserStorer {
    func save(isLogin: Bool) {
        defaults.set(isLogin, forKey: Constants.isLogin)
    }
    
    
    func save(username: String) {
        defaults.set(username, forKey: Constants.username)
    }
    
    func save(email: String) {
        defaults.set(email, forKey: Constants.email)
    }
    
    func save(accountType: String) {
        defaults.set(accountType, forKey: Constants.accountType)
    }
    
    func save(profileImage: String?) {
        defaults.set(profileImage ?? "", forKey: Constants.profileImage)
    }
    
    func save(token: String) {
        defaults.set(token, forKey: Constants.token)
    }
    
    func save(userId: String) {
        defaults.set(userId, forKey: Constants.userId)
    }
    
    func removeToken() {
        defaults.removeObject(forKey: Constants.token)
    }
    
    func save(user: UserResponseModel) {
        let jsonString = user.toJSONString(prettyPrint: true)
        defaults.set(jsonString, forKey: Constants.user)
    }
}
