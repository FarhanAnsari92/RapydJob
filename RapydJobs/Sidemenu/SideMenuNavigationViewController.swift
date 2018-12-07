//
//  SideMenuNavigationViewController.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuNavigationViewController: UISideMenuNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuManager.menuPushStyle = .replace
        self.sideMenuManager.menuPresentMode = .menuSlideIn
        self.sideMenuManager.menuAnimationOptions = .curveEaseIn
        self.sideMenuManager.menuFadeStatusBar = false
        self.menuWidth = self.view.bounds.size.width * 0.85
    }
}
