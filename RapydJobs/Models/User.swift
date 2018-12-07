//
//  User.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 26/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    
    var name: String
    var subtitle: String
    var image: UIImage
    var userType: AccountType
    
    init(_ name: String, _ subtitle: String, _ imageName: String, _ userType: AccountType) {
        self.name = name
        self.subtitle = subtitle
        self.image = UIImage(named: imageName) ?? UIImage()
        self.userType = userType
    }
    
    static func getCurrentUser() -> User {
        return User.mockUser(ofType: .employer)
    }
    
    // For Testing
    static func mockUser(ofType userType: AccountType) -> User {
        let user = User("John Doe", "johndoe@email.com", "face.jpg", userType)
        return user
    }
}
