//
//  BaseViewController.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import SideMenu
import MBProgressHUD

class BaseViewController: UIViewController {

    var activeCallCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting nav items
        if EventFlowManager.shouldShowBackButton == false {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showSideMenu))
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }

        // Side Menu
        if (self.navigationController != nil) {
            let sideMenuVC = UIStoryboard.init(name: UIStoryboard.Name.sidemenu.rawValue, bundle: Bundle.main).instantiateViewController(withIdentifier: "SideMenuNavigationViewController") as! SideMenuNavigationViewController
            SideMenuManager.default.menuLeftNavigationController = sideMenuVC
            SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
            SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view, forMenu: .left)
        }
        
        // Gradient
        addGradient(withRatio: 0.5)
        
        // Call counter
        activeCallCounter = 0
    }
    
    @objc func showSideMenu() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func showProgressView() {
        
        if activeCallCounter == 0 {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        activeCallCounter += 1
    }
    
    func hideProgressView() {
        
        if activeCallCounter == 1 {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        activeCallCounter -= 1
    }
}

class EventFlowManager {
    static var shouldShowBackButton: Bool = false
}
