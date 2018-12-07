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
        sectors.append(Sector(sectorImage: "ic_customer_sales", sectorTitle: "Customer Sales"))
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
    
}
