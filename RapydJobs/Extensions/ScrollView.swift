//
//  ScrollView.swift
//  RapydJobs
//
//  Created by Muhammad Khan on 18/10/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class ScrollView: UIScrollView {

    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}
