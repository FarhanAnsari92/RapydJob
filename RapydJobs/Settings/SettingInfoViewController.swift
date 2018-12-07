//
//  SettingInfoViewController.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 09/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class SettingInfoViewController: BaseViewController {

    public var titleString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = titleString
        self.navigationItem.leftBarButtonItem = nil
    }
}

extension SettingInfoViewController: Initializable {
    static var storyboardName: String {
        return UIStoryboard.Name.settings.rawValue
    }
}
