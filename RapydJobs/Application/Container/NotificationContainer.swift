//
//  NotificationContainer.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 2/1/19.
//  Copyright © 2019 chymps. All rights reserved.
//

import Foundation
/*
 //Jobseeker Notifications Type
 case JobSeekerTimesheet
 case InterviewSchedule
 case JobOfferSend
 case JobseekerChat
 
 //Employer Notifications Type:
 case OrganisationTimesheet
 case JobOfferResponse
 case OrganizationChat
 
 case interviewNotification
 */

protocol NotificationProvider {
    var JobSeekerTimesheet: Bool { get }
    var InterviewSchedule: Bool { get }
    var JobOfferSend: Bool { get }
    var JobseekerChat: Bool { get }
    
    var OrganisationTimesheet: Bool { get }
    var JobOfferResponse: Bool { get }
    var OrganizationChat: Bool { get }
    
    var interviewNotification: Bool { get }
}

protocol NotificationStorer {
    func save(JobSeekerTimesheet: Bool)
    func save(InterviewSchedule: Bool)
    func save(JobOfferSend: Bool)
    func save(JobseekerChat: Bool)
    
    func save(OrganisationTimesheet: Bool)
    func save(JobOfferResponse: Bool)
    func save(OrganizationChat: Bool)
    
    func save(interviewNotification: Bool)
}

class NotificationContainer {
    
    private enum Constants {
        static let JobSeekerTimesheet = "JobSeekerTimesheet"
        static let InterviewSchedule = "InterviewSchedule"
        static let JobOfferSend = "JobOfferSend"
        static let JobseekerChat = "JobseekerChat"
        
        //Employer Notifications Type:
        static let OrganisationTimesheet = "OrganisationTimesheet"
        static let JobOfferResponse = "JobOfferResponse"
        static let OrganizationChat = "OrganizationChat"
        
        static let interviewNotification = "interviewNotification"
    }
    
    var defaults: UserDefaults
    init() {
        defaults = UserDefaults.standard
    }
}

extension NotificationContainer: NotificationProvider {
    var JobSeekerTimesheet: Bool {
        return defaults.bool(forKey: Constants.JobSeekerTimesheet)
    }
    
    var InterviewSchedule: Bool {
        return defaults.bool(forKey: Constants.InterviewSchedule)
    }
    
    var JobOfferSend: Bool {
        return defaults.bool(forKey: Constants.JobOfferSend)
    }
    
    var JobseekerChat: Bool {
        return defaults.bool(forKey: Constants.JobseekerChat)
    }
    
    var OrganisationTimesheet: Bool {
        return defaults.bool(forKey: Constants.OrganisationTimesheet)
    }
    
    var JobOfferResponse: Bool {
        return defaults.bool(forKey: Constants.JobOfferResponse)
    }
    
    var OrganizationChat: Bool {
        return defaults.bool(forKey: Constants.OrganizationChat)
    }
    
    var interviewNotification: Bool {
        return defaults.bool(forKey: Constants.interviewNotification)
    }
}

extension NotificationContainer: NotificationStorer {
    func save(JobSeekerTimesheet: Bool) {
        defaults.set(JobSeekerTimesheet, forKey: Constants.JobSeekerTimesheet)
    }
    
    func save(InterviewSchedule: Bool) {
        defaults.set(InterviewSchedule, forKey: Constants.InterviewSchedule)
    }
    
    func save(JobOfferSend: Bool) {
        defaults.set(JobOfferSend, forKey: Constants.JobOfferSend)
    }
    
    func save(JobseekerChat: Bool) {
        defaults.set(JobseekerChat, forKey: Constants.JobseekerChat)
    }
    
    func save(OrganisationTimesheet: Bool) {
        defaults.set(OrganisationTimesheet, forKey: Constants.OrganisationTimesheet)
    }
    
    func save(JobOfferResponse: Bool) {
        defaults.set(JobOfferResponse, forKey: Constants.JobOfferResponse)
    }
    
    func save(OrganizationChat: Bool) {
        defaults.set(OrganizationChat, forKey: Constants.OrganizationChat)
    }
    
    func save(interviewNotification: Bool) {
        defaults.set(interviewNotification, forKey: Constants.interviewNotification)
    }
    
    
}
