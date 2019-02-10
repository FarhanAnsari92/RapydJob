//
//  EditProfileFlowManager.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/21/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class EditProfileFlowManager {
    
    private init() { }
    
    private static var sharedEditProfileFlowManager: EditProfileFlowManager = {
       return EditProfileFlowManager()
    }()
    
    class func shared() -> EditProfileFlowManager {
        return sharedEditProfileFlowManager
    }
    
    var isEditProfile: Bool = false
    var isHomeScreen: Bool = true
    
}
