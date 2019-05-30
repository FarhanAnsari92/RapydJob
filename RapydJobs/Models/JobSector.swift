//
//  JobSector.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 27/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit

class JobSector {
    let name: String
    let image: UIImage
    
    init(_ name: String, _ imageName: String) {
        self.name = name
        self.image = UIImage(named: imageName) ?? UIImage()
    }
    
    static private func createJobSectorItems() -> [JobSector] {
        let admin = JobSector("Admin", "ic_admin")
        let bar = JobSector("Bar", "ic_bar")
        let callcenter = JobSector("Call Center", "ic_call_center")
        let catering = JobSector("Catering", "ic_catering")
        let charity = JobSector("Charity", "ic_charity")
        let childcare = JobSector("Childcare", "ic_childcare")
        let cleaning = JobSector("Cleaning", "ic_cleaning")
        let construction = JobSector("Construction", "ic_construction")
        let customerSales = JobSector("Customer Services", "ic_customer_sales")
        let finance = JobSector("Finance", "ic_finance")
        let health = JobSector("Health", "ic_health")
        let it = JobSector("IT", "ic_it")
        let publicsector = JobSector("Public Sector", "ic_public_sector")
        let retail = JobSector("Retail", "ic_retail")
        let sales = JobSector("Sales", "ic_sales")
        return [admin, bar, callcenter, catering, charity, childcare, cleaning, construction, customerSales, finance, health, it, publicsector, retail, sales]
    }
    
    static func getJobSectorsFromPersistance() -> [JobSector] {
        return JobSector.createJobSectorItems()
    }
}
