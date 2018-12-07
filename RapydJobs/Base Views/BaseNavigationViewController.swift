//
//  BaseNavigationViewController.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationBar.titleTextAttributes = textAttributes
        self.navigationBar.tintColor = UIColor.white
    }
}
