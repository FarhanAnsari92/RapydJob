//
//  UIAlertController+Error.swift
//  RapydJobs
//
//  Created by Maroof Khan on 28/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(error: NetworkError) {
        self.init(title: error.title, message: error.message, preferredStyle: .alert)
        self.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
}
