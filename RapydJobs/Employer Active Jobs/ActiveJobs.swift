//
//  ActiveJobs.swift
//  RapydJobs
//
//  Created by Muhammad Khan on 17/10/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class ActiveJobs: BaseViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        
        title = "Job Vacancies"
    }

}

extension ActiveJobs: Initializable {
    static var storyboardName: String {
        return UIStoryboard.Name.activeJobs.rawValue
    }
}
