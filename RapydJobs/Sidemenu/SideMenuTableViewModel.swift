//
//  SideMenuTableViewModel.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit

class SideMenuTableViewModel: NSObject {
    
    var data = [SideMenuItem]()

    override init() {
        super.init()
        
        data = self.menuItemsForUserType((AppContainer.shared.user.user?.accountType)!)
    }
    
    func menuItemsForUserType(_ accountType:String) -> [SideMenuItem] {
        
        let shortListedVC = CardViewController.getInstance()
        shortListedVC.cardFlow = .shortlisted
        
        let moveToHome = SideMenuItem("Home", "home", CardViewController.getInstance())
        let postAJobItem = SideMenuItem("Post A Job", "ic_postajob", CreateJobVC.getInstance())
        let matchesItem = SideMenuItem("Matches", "ic_matches", MatchesViewController.getInstance())
        let interviewsItem = SideMenuItem("Interviews", "ic_interviews", InterviewsViewController.getInstance())
        
        let shortListVC = SideMenuItem("Shortlisted", "ic_shortlisted", ShortListViewController.getInstance())
        
        let jobListOrg = SideMenuItem("Jobs", "ic_shortlisted", JobListOrganizationViewController.getInstance())
        
        let jobListSeeker = SideMenuItem("Job Offers", "job_offer", JobListSeekerViewController.getInstance())
        let hrItem = SideMenuItem("HR", "ic_jobs", HRVC.getInstance())
        let settingItems = SideMenuItem("Settings", "ic_settings", SettingsViewController.getInstance())
        
        let profileItem = SideMenuItem("My Profile", "ic_my_profile", ProfileDetailsViewController.getInstance())
        let scheduledIntItem = SideMenuItem("Scheduled Interviews", "ic_interviews", ScheduleInterviewViewController.getInstance())
        
        let jobseekerTimesheet = SideMenuItem("Timesheet","ic_interviews", JobseekerTimesheetViewController.getInstance())
        
        let employerTimesheet = SideMenuItem("Timesheet","ic_interviews", EmployerTimesheetViewController.getInstance())

        switch accountType {
        case "organization":
            return [moveToHome, postAJobItem, matchesItem, interviewsItem, shortListVC, employerTimesheet, jobListOrg, hrItem, settingItems]
        case "jobseeker":
            return [moveToHome, profileItem, matchesItem, scheduledIntItem, shortListVC, jobseekerTimesheet, jobListSeeker, settingItems]
        default:
            return [moveToHome]
        }
    }
    
    func numberOfRows() -> Int {
        return data.count
    }
}
