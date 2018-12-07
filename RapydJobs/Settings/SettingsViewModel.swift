//
//  SettingsViewModel.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 01/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class SettingsViewModel: NSObject {
    
    static func createSettingData() -> [SettingModel]{
        
        // JobSectos
        let jobSectors = AppContainer.shared.job.jobSectors
        var jobs = ""
        
        for job in jobSectors {
            if job.value {
                jobs.append("\(job.key), ")
            }
        }
        
        if jobs.count == 0 {
            jobs = "No Jobs Sectors Selected"
        }
        
        // Rows
        let salaryRow = SettingRowModel("£25", .edit)
        let jobRow = SettingRowModel(jobs, .edit)
        let changePassRow = SettingRowModel("Change Password", .edit)
        let notificationRow = SettingRowModel("Turn on the notifications", .notification)
        let termsRow = SettingRowModel("Terms & conditions", .disclose)
        let privacysRow = SettingRowModel("Privacy policy", .disclose)
        let shareAppRow = SettingRowModel("Share app", .normal)
        let deleteAccRow = SettingRowModel("Delete account", .normal)
        let signoutRow = SettingRowModel("Sign out", .alert)

        
        // Sections
        let salaryModel = SettingModel("Salary Per Hour", [salaryRow])
        let jobSectorModel = SettingModel("Job Sector", [jobRow])
        let privacyModel = SettingModel("Privacy Settings", [changePassRow])
        let notificationModel = SettingModel("Notification Settings", [notificationRow])
        let aboutModel = SettingModel("About App", [termsRow, privacysRow, shareAppRow, deleteAccRow, signoutRow])

        return [salaryModel, jobSectorModel, privacyModel, notificationModel, aboutModel]
    }

    let data: [SettingModel] = createSettingData()
    
    func numberOfSections() -> Int {
        return data.count
    }
    
    func numberOfRowsInSection(_ section:Int) -> Int {
        return data[section].rows.count
    }
    
    func sectionModelForIndexPath(_ section:Int) -> SettingModel {
        return data[section]
    }
    
    func rowModelForIndexPath(_ indexPath:IndexPath) -> SettingRowModel {
        return sectionModelForIndexPath(indexPath.section).rows[indexPath.row]
    }
}
