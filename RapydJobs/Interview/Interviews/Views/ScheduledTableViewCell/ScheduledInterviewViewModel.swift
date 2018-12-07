//
//  ScheduledInterviewViewModel.swift
//  RapydJobs
//
//  Created by Maroof Khan on 15/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

final class ScheduledInterviewViewModel {
    let candidate: Candidate
    let time: Time
    
    init(interview: Interview) {
        self.candidate = interview.candidate
        self.time = interview.time
    }
}
