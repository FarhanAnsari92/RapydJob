//
//  AuthResponse.swift
//  RapydJobs
//
//  Created by Maroof Khan on 27/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

struct AuthResponse: DTO {
    let id: Int
    let username: String
    let email: String
    let account_type: String
    let profile_image: String?
    let created_at: String
    let updated_at: String
    let device_token: String?
    let device: String?
    let longitude: String?
    let fcm: String?
    let status: String
    let access_token: String
}
