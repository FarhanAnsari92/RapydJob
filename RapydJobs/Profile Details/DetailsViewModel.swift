//
//  DetailsViewModel.swift
//  RapydJobs
//
//  Created by Maroof Khan on 07/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

struct SegmentData {
    let title: String
    let datasource: UITableViewDataSource
    let behaviour: UITableViewDelegate
}

protocol Details {
    
    var title: String { get }
    var subtitle: String { get }
    var cta: String { get }
    var segment: [SegmentData] { get }
    var rating: Int? { get }
    var accept: (() -> Void)? { get }
    var reject: (() -> Void)? { get }
    var display: UIImage { get }
    var cover: UIImage { get }
    func numberOfRows(segment: Int) -> Int
}
