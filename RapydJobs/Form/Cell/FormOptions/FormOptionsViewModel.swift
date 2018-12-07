//
//  FormOptionsViewModel.swift
//  RapydJobs
//
//  Created by Maroof Khan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import ReactiveSwift

struct FormOptionsViewModel {
    let title: String
    let options: [String]
    let selected: MutableProperty<String>
    weak var persenter: FormViewModelDelegate?
}
