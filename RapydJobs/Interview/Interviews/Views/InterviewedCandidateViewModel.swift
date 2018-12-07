//
//  InterviewedCandidateViewModel.swift
//  RapydJobs
//
//  Created by Maroof Khan on 15/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class InterviewedCandidateViewModel {
    let candidate: Candidate
    
    init(interview: Interview) {
        self.candidate = interview.candidate
    }
}
