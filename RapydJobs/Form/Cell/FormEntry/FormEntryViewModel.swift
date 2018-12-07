//
//  FormEntryViewModel.swift
//  RapydJobs
//
//  Created by Maroof Khan on 20/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class FormEntryViewModel {
    let title: String
    let place: String
    let time: String
    var expanded: Bool
    
    init(title: String, place: String, time: String) {
        self.title = title
        self.place = place
        self.time = time
        self.expanded = false
    }
}
