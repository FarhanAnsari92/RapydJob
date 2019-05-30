//
//  Helper.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/3/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    class func getSectors() -> [Sector] {
        var sectors = [Sector]()
        
        sectors.append(Sector(sectorImage: "ic_admin", sectorTitle: "Admin"))
        sectors.append(Sector(sectorImage: "ic_bar", sectorTitle: "Bar"))
        sectors.append(Sector(sectorImage: "ic_call_center", sectorTitle: "Call Center"))
        sectors.append(Sector(sectorImage: "ic_catering", sectorTitle: "Catering"))
        sectors.append(Sector(sectorImage: "ic_charity", sectorTitle: "Charity"))
        sectors.append(Sector(sectorImage: "ic_childcare", sectorTitle: "Childcare"))
        sectors.append(Sector(sectorImage: "ic_cleaning", sectorTitle: "Cleaning"))
        sectors.append(Sector(sectorImage: "ic_construction", sectorTitle: "Construction"))
        sectors.append(Sector(sectorImage: "ic_customer_sales", sectorTitle: "Customer Services"))
        sectors.append(Sector(sectorImage: "ic_finance", sectorTitle: "Finance"))
        sectors.append(Sector(sectorImage: "ic_health", sectorTitle: "Health"))
        sectors.append(Sector(sectorImage: "ic_it", sectorTitle: "IT"))
        sectors.append(Sector(sectorImage: "ic_public_sector", sectorTitle: "Public Sector"))
        sectors.append(Sector(sectorImage: "ic_retail", sectorTitle: "Retail"))
        sectors.append(Sector(sectorImage: "ic_sales", sectorTitle: "Sales"))
        
        return sectors
    }
    
    public class func delay(_ delay:Double, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    class func getRedDot() {
        
        _ = APIClient.callAPI(request: .getRedDot, onSuccess: { (dictionary) in
            
            print(dictionary)
            
            if AppContainer.shared.user.user?.accountType == "organization" {
                
                let isEmpTimesheet = dictionary["emp_timesheet"] as! Int == 1
                let isJobOfferResponse = dictionary["jobofferresponse"] as! Int == 1
                let isEmpMessage = dictionary["emp_message"] as! Int == 1
                
                AppContainer.shared.notificationContainer.save(OrganisationTimesheet: isEmpTimesheet)
                AppContainer.shared.notificationContainer.save(JobOfferResponse: isJobOfferResponse)
                if isEmpMessage {
                    NotificationCenter.default.post(name: .messageNotificationName, object: nil)
                }
                AppContainer.shared.notificationContainer.save(Chat: isEmpMessage)
                
            } else { // Seeker
                
                let isJobSeekerTimesheet = dictionary["emp_timesheet"] as! Int == 1
                let isInterview = dictionary["interview"] as! Int == 1
                let isJobseekerMessage = dictionary["jobseeker_message"] as! Int == 1
                let isJobOffer = dictionary["joboffer"] as! Int == 1
                
                AppContainer.shared.notificationContainer.save(JobSeekerTimesheet: isJobSeekerTimesheet)
                AppContainer.shared.notificationContainer.save(InterviewSchedule: isInterview)
                AppContainer.shared.notificationContainer.save(JobOfferSend: isJobOffer)
                if isJobseekerMessage {
                    NotificationCenter.default.post(name: .messageNotificationName, object: nil)
                }
                AppContainer.shared.notificationContainer.save(Chat: isJobseekerMessage)
                
            }
            
            
            
            
        }) { (errorDic, _) in
            print(errorDic)
        }
        
    }
    
    class func changeRedDot(type: String) {
        var param = Dictionary<String,Any>()
        param["type"] = type
        print(param)
        _ = APIClient.callAPI(request: .changeRedDot(param: param), onSuccess: { (dictionary) in
            print(dictionary)
        }, onFailure: { (errorDictionary, _) in
            print(errorDictionary)
        })
    }
    
    class func openJobSeekerProfile(_ controller: UIViewController,jobId: Int?) {
        guard let id = jobId else {
            return
        }
        let profileDetailsVC = JobSeekerProfileViewController.getInstance()
        profileDetailsVC.jobseekerId = id
        controller.navigationController?.pushViewController(profileDetailsVC, animated: true)
        
    }
    
    class func openJobDetail(_ controller: UIViewController, jobId: Int?) {
        
        guard let id = jobId else {
            return
        }
        
        let sb = UIStoryboard(name: "JobDetails", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! JobDetailsViewController
        vc.jobId = "\(id)"
        controller.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
