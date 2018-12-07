//
//  JobModel.swift
//  RapydJobs
//
//  Created by Maroof Khan on 08/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class JobModel {
    let title: String
    let company: String // should be Company
    let display: UIImage
    let cover: UIImage
    let location: String // should be Location
    let budget: String // should be Budget
    let time: String // should be Time
    let description: String
    let candidates: [String] // should be [Candidate]
    
    init(title: String, company: String, display: UIImage, cover: UIImage, location: String, budget: String, time: String, description: String, candidates: [String]) {
        self.title = title
        self.company = company
        self.display = display
        self.cover = cover
        self.location = location
        self.budget = budget
        self.time = time
        self.description = description
        self.candidates = candidates
    }
}
