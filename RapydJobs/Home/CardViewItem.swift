//
//  CardViewItem.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 24/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit

class CardViewItem {
    
    var title: String
    var subtitle: String
    var image: UIImage
    var rating: Double
    var description: String
    var jobTitle: String
    var education: String
    var location: String
    var shouldHide: Bool = true
    init(_ title:String, _ subtitle:String, _ imageName:String, _ rating:Double, _ description:String, _ jobTitle:String, _ education:String, _ location:String) {
        self.title = title
        self.subtitle = subtitle
        self.image = UIImage(named: imageName) ?? UIImage()
        self.rating = rating
        self.description = description
        self.jobTitle = jobTitle
        self.education = education
        self.location = location
    }
}
