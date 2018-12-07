//
//  Jobseeker.swift
//  RapydJobs
//
//  Created by Muhammad Khan on 07/10/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

struct JobseekerModel {

	let id : Int
	let updatedAt : String
	let accountType : String
	let address : Addres
	let createdAt : String
	let device : String
	let deviceToken : String
	let education : [JobseekerEducation]
	let email : String
	let experience : [JobseekerExperience]
	let fcm : String
	let latitude : String
	let longitude : String
	let passwordToken : String
	let profileImage : String
	let status : String
	let totalRating : Int
	let username : String
    let jobseeker: Jobseeker
}
