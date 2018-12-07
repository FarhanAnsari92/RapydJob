//
//  SideMenuItem.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import UIKit

class SideMenuItem: NSObject {
    
    var title:String
    var image:UIImage
    var viewController:UIViewController
    
    init(_ title:String, _ imageName:String, _ viewController:UIViewController) {
        self.title = title
        self.viewController = viewController
        self.image = UIImage(named: imageName) ?? UIImage()
    }
}
