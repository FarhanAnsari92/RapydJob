//
//  RelatedFieldsCellModel.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 01/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit

class RelatedFieldsCellModel: NSObject {
    
    var title: String
    var image: UIImage
    var isActive: Bool
    
    init(_ title: String, _ image: UIImage, _ isActive: Bool) {
        self.title = title
        self.image = image
        self.isActive = isActive
    }
}
