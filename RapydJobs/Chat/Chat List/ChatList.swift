//
//  ChatList.swift
//  RapydJobs
//
//  Created by MuhammadKhan on 8/26/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

struct ChatList {
    
    let name: String
    let messages: [Message]
    let id: String
    let updatedAt: String
    let pivot: Pivot
    let createdAt: String
    let jobId: String
    let users: [ChatUser]
}

struct Pivot {
    
    let conversationId: Int
    let userId: Int
}

struct ChatUser {
    
    let accountType : String
    let createdAt : String
    let device : String
    let deviceToken : String
    let email : String
    let fcm : String
    let id : Int
    let latitude : String
    let longitude : String
    let passwordToken : String
    let pivot : Pivot
    let profileImage : String
    let status : String
    let updatedAt : String
    let username : String
}
