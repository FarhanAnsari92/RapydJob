//
//  InterviewsViewModel.swift
//  RapydJobs
//
//  Created by Maroof Khan on 15/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import Segmentio

class InterviewsViewModel {
    let interviews: [Interview]
    let interviewed: [Candidate]
    let segmentData: [SegmentioItem]
    
    init(interviews: [Interview], interviewed: [Candidate]) {
        self.interviews = interviews
        self.interviewed = interviewed
        self.segmentData = ["Scheduled", "Interviewed"].map {
            SegmentioItem(title: $0, image: nil)
        }
    }
}
