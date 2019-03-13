//
//  APIClient.swift
//  BYKEA
//
//  Created by BYKEA - Muhammad Farhan on 23/01/2018.
//  Copyright © 2018 Bykea Technologies. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper
//import SocketIO

enum APIClient: URLRequestConvertible {
    /// Base URL for webservice - Configure in Constants.swift
    
    //http://ec2-18-191-9-134.us-east-2.compute.amazonaws.com/RapydJobs/public/api/
    //http://ec2-18-191-9-134.us-east-2.compute.amazonaws.com/RapydJobs/storage/cv/
    static let scheme = "http://"
     
     static let host = "ec2-18-191-9-134.us-east-2.compute.amazonaws.com/"
     
     static let path = "RapydJobs/public/api/"
 
    
    static let baseURL = URL(string: "\(scheme)\(host)\(path)")
    
    static var socketConnected = false
    static var socketError = false
    
    case login(param: [String: Any])
    case superLikeEmployerRequest(param: [String: Any])
    case superlikeJobSeekerRequest(param: [String:Any])
    case myProfileOrganization
    case getInterView(type: String)
    case likeEmployeeRequest(param: [String:Any])
    case dropDown
    case getShortListedJobSeeker(endPoint: Int)
    case scheduleInterview(param: [String:Any])
    case getContracts(page: Int)
    case makeOffer(param: [String:Any])
    case updateInterview(interviewId: Int, param: [String:Any])
    case reject(interviewId: Int)
    case organizationJobsLists(limit: Int, type: String, page: Parameters)
    case deleteJob(id: Int)
    case updateJob(id: Int, param: [String:Any])
    case getManagedEmployees(Status: String)
    case updateEmployee(hireId: Int, param: [String:Any])
    case sendReview(param: [String:Any])
    case deleteHiredEmployee(hireId: Int)
    case logout
    case getSignedContract(page: Int)
    case getJobSeekerMatchList
    case getShortListedOrganization
    case shortListJob(param: [String:Any])
    case shortListSeeker(param: [String:Any])
    case likeJobRequest(param: [String:Any])
    case sendMessage(param: [String:Any])
    case getJobOffers(type: String, limit: Int, page: Int)
    case acceptJoboffer(param: [String:Any])
    case getJobseekerInterview(page: Int)
    case deleteContract(contractId: Int)
    case myReview(numberOfItems: Int, page: Int)
    //--- Edit Profile
    case addExperience(param: [String:Any])
    case deleteExperience(id: Int)
    case updateExperience(param: [String:Any], id: Int)
    
    case addEducation(param: [String:Any])
    case updateEducation(param: [String:Any], id: Int)
    
    case addLanguage(param: [String:Any])
    case updateLanguage(param: [String:Any], id: Int)
    
    case updateJobSeeker(param: [String:Any])
    case getJobseeker(id: Int)
    
    case review(id: Int, numberOfItems: Int, page: Int)
    case updateTimesheet(param: [String:Any], timesheetId: Int)
    
    //Timesheet
    case jobseekerTimesheet(param: [String:Any])
    case employerTimesheet(param: [String:Any])
    
    case socialRegister(param: [String:Any])
    case organizationHireDropdown
    case jobseekerHireDropdown
    case jobseekerPlanner(id: Int?)
    case organizationPlanner(id: Int?)
    case getJobDetail(jobId: String)
    case getConversation(conversationId: String, page: Int)
    case resendCode
    
    case createTimesheet(param: [String:Any])
    
    case getRedDot

    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .login,
                 .likeEmployeeRequest,
                 .scheduleInterview,
                 .makeOffer,
                 .sendReview,
                 .superlikeJobSeekerRequest,
                 .shortListJob,
                 .shortListSeeker,
                 .likeJobRequest,
                 .sendMessage,
                 .acceptJoboffer,
                 .addExperience,
                 .addLanguage,
                 .addEducation,
                 .jobseekerTimesheet,
                 .employerTimesheet,
                 .socialRegister,
                 .createTimesheet,
                 .superLikeEmployerRequest:
                return .post
            case .myProfileOrganization,
                 .dropDown,
                 .getShortListedJobSeeker,
                 .getContracts,
                 .organizationJobsLists,
                 .getManagedEmployees,
                 .logout,
                 .getSignedContract,
                 .getJobSeekerMatchList,
                 .getShortListedOrganization,
                 .getJobOffers,
                 .getJobseekerInterview,
                 .myReview,
                 .getJobseeker,
                 .review,
                 .organizationHireDropdown,
                 .jobseekerHireDropdown,
                 .jobseekerPlanner,
                 .organizationPlanner,
                 .getJobDetail,
                 .getConversation,
                 .resendCode,
                 .getRedDot,
                 .getInterView:
                return .get
            case .updateInterview,
                 .updateEmployee,
                 .updateJobSeeker,
                 .updateExperience,
                 .updateLanguage,
                 .updateEducation,
                 .updateTimesheet,
                 .updateJob:
                return .put
            case .reject,
                 .deleteHiredEmployee,
                 .deleteContract,
                 .deleteExperience,
                 .deleteJob:
                return .delete
            }
        }

        /// Parameters for Webservice API request
        let params: ([String: Any]?) = {
            switch self {
            case .login(let param):
                return param
            case .superLikeEmployerRequest(let param):
                return param
            case .myProfileOrganization,
                 .dropDown,
                 .getShortListedJobSeeker,
                 .getContracts,
                 .reject,
                 .deleteJob,
                 .getManagedEmployees,
                 .deleteHiredEmployee,
                 .logout,
                 .getSignedContract,
                 .getJobSeekerMatchList,
                 .getShortListedOrganization,
                 .getJobOffers,
                 .getJobseekerInterview,
                 .deleteContract,
                 .myReview,
                 .deleteExperience,
                 .getJobseeker,
                 .review,
                 .organizationHireDropdown,
                 .jobseekerHireDropdown,
                 .jobseekerPlanner,
                 .organizationPlanner,
                 .getJobDetail,
                 .getConversation,
                 .resendCode,
                 .getRedDot,
                 .getInterView:
                return nil
            case .likeEmployeeRequest(let param):
                return param
            case .scheduleInterview(let param):
                return param
            case .makeOffer(let param):
                return param
            case .updateInterview(_, let param):
                return param
            case .organizationJobsLists(_, _, let param):
                return param
            case .updateJob(_, let param):
                return param
            case .updateEmployee(_, let param):
                return param
            case .sendReview(let param):
                return param
            case .superlikeJobSeekerRequest(let param):
                return param
            case .shortListJob(let param):
                return param
            case .shortListSeeker(let param):
                return param
            case .likeJobRequest(let param):
                return param
            case .sendMessage(let param):
                return param
            case .acceptJoboffer(let param):
                return param
            case .addExperience(let param):
                return param
            case .updateJobSeeker(let param):
                return param
            case .updateExperience(let param, _):
                return param
            case .addLanguage(let param):
                return param
            case .updateLanguage(let param, _):
                return param
            case .addEducation(let param):
                return param
            case .updateEducation(let param, _):
                return param
            case .jobseekerTimesheet(let param):
                return param
            case .employerTimesheet(let param):
                return param
            case .updateTimesheet(let param, _):
                return param
            case .socialRegister(let param):
                return param
            case .createTimesheet(let param):
                return param
            }
        }()
        
        //Headers
        let header: ([String:String]?) = {
            switch self {
            case .login:
                return [ "Accept" : "application/json" ]
            case .myProfileOrganization,
                 .getInterView,
                 .likeEmployeeRequest,
                 .dropDown,
                 .getShortListedJobSeeker,
                 .scheduleInterview,
                 .getContracts,
                 .makeOffer,
                 .updateInterview,
                 .reject,
                 .organizationJobsLists,
                 .deleteJob,
                 .updateJob,
                 .getManagedEmployees,
                 .updateEmployee,
                 .sendReview,
                 .deleteHiredEmployee,
                 .logout,
                 .getSignedContract,
                 .getJobSeekerMatchList,
                 .superlikeJobSeekerRequest,
                 .getShortListedOrganization,
                 .shortListJob,
                 .shortListSeeker,
                 .likeJobRequest,
                 .sendMessage,
                 .getJobOffers,
                 .acceptJoboffer,
                 .getJobseekerInterview,
                 .deleteContract,
                 .myReview,
                 .deleteExperience,
                 .addExperience,
                 .updateJobSeeker,
                 .updateExperience,
                 .addLanguage,
                 .updateLanguage,
                 .addEducation,
                 .getJobseeker,
                 .updateEducation,
                 .review,
                 .jobseekerTimesheet,
                 .employerTimesheet,
                 .updateTimesheet,
                 .socialRegister,
                 .organizationHireDropdown,
                 .jobseekerHireDropdown,
                 .jobseekerPlanner,
                 .organizationPlanner,
                 .getJobDetail,
                 .getConversation,
                 .resendCode,
                 .createTimesheet,
                 .getRedDot,
                 .superLikeEmployerRequest:
                guard let token = AppContainer.shared.user.user?.accessToken else {
                    return nil
                }
                return ["Authorization" : "Bearer \(token)", "Accept" : "application/json"]
            }
            
        }()

        /// API Endpoint
        let relativePath: String = {
            switch self {
            case .login:
                return "oauth/token"
            case .superLikeEmployerRequest:
                return "organization-super-like"
            case .myProfileOrganization:
                return "my-profile-organization"
            case .getInterView(let type):
                return "organization-interview/\(type)"
            case .likeEmployeeRequest:
                return "add-swipe-user"
            case .dropDown:
                return "organization-dropdown-jobs"
            case .getShortListedJobSeeker(let endPoint):
                return "show-shortlisted-jobseekers/\(endPoint)"
            case .scheduleInterview:
                return "store-interview"
            case .getContracts(let page):
                return "contract?page=\(page)"
            case .makeOffer:
                return "store-joboffer"
            case .updateInterview(let interviewId, _):
                return "update-interview/\(interviewId)"
            case .reject(let interviewId):
                return "delete-interview/\(interviewId)"
            case .organizationJobsLists(let limit, let type, _):
                return "organization-jobs/\(limit)/\(type)?page=1"
            case .deleteJob(let id):
                return "delete-job/\(id)"
            case .updateJob(let id, _):
                return "update-job/\(id)"
            case .getManagedEmployees(let status):
                return "managed-employees/\(status)"
            case .updateEmployee(let hireId, _):
                return "update-hireemployee/\(hireId)"
            case .sendReview:
                return "store-review"
            case .deleteHiredEmployee(let hireId):
                return "delete-hireemployee/\(hireId)"
            case .logout:
                return "logout"
            case .getSignedContract(let page):
                return "signed-contract?page=\(page)"
            case .getJobSeekerMatchList:
                return "jobseeker-matches/1"
            case .superlikeJobSeekerRequest:
                return "jobseeker-super-like"
            case .getShortListedOrganization:
                return "show-shortlisted-jobs"
            case .shortListJob:
                return "store-shortlist-jobs"
            case .shortListSeeker:
                return "store-shortlist-jobseekers"
            case .likeJobRequest:
                return "add-swipe-job"
            case .sendMessage:
                return "message"
            case .getJobOffers(let type, let limit, let page):
                return "joboffer/\(limit)/\(type)?page=\(page)"
            case .acceptJoboffer:
                return "accept-joboffer"
            case .getJobseekerInterview(let page):
                return "jobseeker-interview/\(page)"
            case .deleteContract(let contractId):
                return "delete-contract/\(contractId)"
            case .myReview(let numberOfItems, let page):
                return "my-review/\(numberOfItems)?page=\(page)"
            case .deleteExperience(let id):
                return "delete-experience/\(id)"
            case .addExperience:
                return "store-experience"
            case .updateJobSeeker:
                return "user"
            case .updateExperience(_ ,let id):
                return "update-experience/\(id)"
            case .addLanguage:
                return "store-language"
            case .updateLanguage(_ ,let id):
                return "update-language/\(id)"
            case .addEducation:
                return "store-education"
            case .updateEducation(_ ,let id):
                return "update-education/\(id)"
            case .getJobseeker(let id):
                return "jobseeker/\(id)"
            case .review(let id, let NumberOfItems, let page):
                return "review/\(id)/\(NumberOfItems)?page=\(page)"
            case .jobseekerTimesheet:
                return "jobseeker-timesheet"
            case .employerTimesheet:
                return "organization-timesheet"
            case .updateTimesheet(_, let timesheetId):
                return "timesheet/\(timesheetId)"
            case .socialRegister:
                return "social-register"
            case .organizationHireDropdown:
                return "organization-hire-job-dropdown"
            case .jobseekerHireDropdown:
                return "jobseeker-hire-job-dropdown"
            case .jobseekerPlanner(let id):
                if let jobId = id {
                    return "jobseeker-planner/\("\(jobId)" )"
                }
                return "jobseeker-planner"
            case .organizationPlanner(let id):
                if let jobId = id {
                    return "organization-planner/\("\(jobId)" )"
                }
                return "organization-planner"
            case .getJobDetail(let jobId):
                return "job/\(jobId)"
            case .getConversation(let conversationId, let page):
                return "conversation/\(conversationId)?page=\(page)"
            case .resendCode:
                return "resend-verification-code"
            case .createTimesheet:
                return "timesheet"
            case .getRedDot:
                return "get-red-dots"
            }
        }()

        // Complete URL
        let url: URL = {
            let url = URL(string: relativePath, relativeTo: APIClient.baseURL)
            print("----------------")
            print("Params - \(String(describing: params))")
            print("URL - \(String(describing: url?.absoluteString))")
            print("----------------")
            return url!
        }()

        // Encode parameters
        let encoding: ParameterEncoding = {            
            switch method {
            case .post: //, .put: //, .get:
                return JSONEncoding()
            default:
                return URLEncoding()
            }
        }()

        // Request for URL
        var urlRequest = URLRequest(url: url)
        // Configuring HTTP method
        urlRequest.httpMethod = method.rawValue
        try urlRequest.setHeaders(header!)
        // Timeout interval for Webservice API request
        urlRequest.timeoutInterval = 15
        
        // Encoding parameters
        return try encoding.encode(urlRequest, with: params)
    }

    /// Call Webservice API
    ///
    /// - Parameters:
    ///   - request: APIClient case
    ///   - showLoader: Bool
    ///   - loaderView: UIView
    ///   - successBlock: Closure for success
    ///   - failureBlock: Closure for failure
    /// - Returns: DataRequest
    static func callAPI(request: APIClient, onSuccess successBlock: (([String: Any]) -> Void)?, onFailure failureBlock: (([String: Any], Bool) -> Void)? = nil) -> DataRequest {
        
        let responseCompletion: (DataResponse<Any>) -> Void = { (response) in
            let handleFailure: (_: [String: Any], _: Any, _: Error?) -> Void = { errorDictionary, log, errorObject in
                var isNetworkError = false
                if let error = errorObject as NSError?, error.code == NSURLErrorNotConnectedToInternet {
                    isNetworkError = true
                }
                failureBlock?(errorDictionary, isNetworkError)
            }
            
            switch response.result {
            case .success(let value):
                if let dictionary = value as? [String:Any] {
                    if let code = response.response?.statusCode {
                        print("Status Code -> \(code)")
                        if code >= 200 && code <= 299 {
                            successBlock?(dictionary)
                        } else if code == 401 {
                            handleFailure(dictionary, "Unable to parse JSON", nil)
                        } else {
                            handleFailure(dictionary, "Something went wrong", nil)
                        }
//
//                        switch code {
//
//                        case 401:
//                            handleFailure(dictionary, "Unable to parse JSON", nil)
//                        default:
//                            successBlock?(dictionary)
//                        }
                    } else {
                        successBlock?(dictionary)
                    }
                } else if let arr = value as? [[String:Any]] {
                    var dict = [String:Any]()
                    dict["data"] = arr
                    successBlock?(dict)
                } else {
                    handleFailure(["message": "Unable to load"], "Unable to parse JSON", nil)
                    return
                }
            case .failure(let error):
                if error.localizedDescription.contains("offline") {
                    REACHABILITY_HELPER.internetConnected = false
                }
                handleFailure(["message": error.localizedDescription], "Unable to parse JSON", error)
            }
        }
        
        return Alamofire.request(request).responseJSON(completionHandler: responseCompletion)
    }
}
