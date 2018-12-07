//
//  JobDetailsViewModel.swift
//  RapydJobs
//
//  Created by Maroof Khan on 08/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import Segmentio

class JobDetailsViewModel {
    
    let segmentData: [SegmentioItem]
    let job: JobModel
    
    init(job: JobModel, shortlist: @escaping () -> Void) {
        self.job = job
        segmentData = ["Details", "Candidates"].map {
            SegmentioItem(title: $0, image: UIImage(named: ""))
        }
    }
    
    var title: String {
        return job.title
    }
    
    var subtitle: String {
        return job.company
    }
    
    var cover: UIImage {
        return job.cover
    }
    
    var display: UIImage {
        return job.display
    }
    
    var location: String {
        return job.location
    }
    
    var budget: String {
        return job.budget
    }
    
    var time: String {
        return job.time
    }
    
    
    func numberOfItems(segment: Int) -> Int {
        switch segment {
        case 0: return 2
        case 1: return job.candidates.count
        default: return 0
        }
    }
}
