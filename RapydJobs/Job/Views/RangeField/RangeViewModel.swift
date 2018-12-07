//
//  RangeViewModel.swift
//  RapydJobs
//
//  Created by Maroof Khan on 02/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ReactiveSwift

final class RangeViewModel {
    
    typealias SlidingRange = (value: Int, title: String, formatter: (Int) -> String)
    
    let title: String
    let minimum: SlidingRange
    let maximum: SlidingRange
    let range: MutableProperty<(Double, Double)>
    
    init(title: String, minimum: SlidingRange, maximum: SlidingRange, range: MutableProperty<(Double, Double)>) {
        self.title = title
        self.minimum = minimum
        self.maximum = maximum
        self.range = range
    }
}
