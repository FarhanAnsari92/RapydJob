//
//  Sector.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/3/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

class Sector {
    var sectorImage: String
    var sectorTitle: String
    var isSelected: Bool
    
    init(sectorImage: String, sectorTitle: String, isSelected: Bool = false) {
        self.sectorImage = sectorImage
        self.sectorTitle = sectorTitle
        self.isSelected = isSelected
    }
}
