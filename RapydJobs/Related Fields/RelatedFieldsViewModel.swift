//
//  RelatedFieldsViewModel.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 01/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class RelatedFieldsViewModel: NSObject {
    
    var data = [RelatedFieldsCellModel]()
    let selected: ((String) -> Void)?
    
    init(selected: ((String) -> Void)? = nil) {
        
        self.selected = selected
        
        let jobSectors = JobSector.getJobSectorsFromPersistance()
        
        var jobSectorsDict = AppContainer.shared.job.jobSectors 

        for i in 0..<jobSectors.count {
            let isActive: Bool = jobSectorsDict[jobSectors[i].name] ?? false
            data.append(RelatedFieldsCellModel(jobSectors[i].name, jobSectors[i].image, isActive))
        }
    }
    
    func numberOfItems() -> Int {
        return data.count
    }
}
