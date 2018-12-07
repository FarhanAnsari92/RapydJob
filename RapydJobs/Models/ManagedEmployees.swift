

import Foundation
import ObjectMapper

class ManagedEmployees: Mappable {
	var fullName : String?
	var hireId : Int?
	var jobId : Int?
	var jobTitle : String?
	var lastExperience : String?
	var profileImage : String?
	var status : String?
	var userId : Int?

    required init?(map: Map) {
        self.mapping(map: map)
	}

    func mapping(map: Map) {

		fullName <- map["fullname"]
		hireId <- map["hire_id"]
		jobId <- map["job_id"]
		jobTitle <- map["job_title"]
		lastExperience <- map["last_experience"]
		profileImage <- map["profile_image"]
		status <- map["status"]
		userId <- map["user_id"]
	}

}
