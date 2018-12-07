//
//  SelectDatesVC.swift
//  RapydJobs
//
//  Created by Muhammad Khan on 16/10/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class SelectDatesVC: UIViewController {

    private let mainStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 20
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let mondayStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 20
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func setupViews() {
        
    }
}
