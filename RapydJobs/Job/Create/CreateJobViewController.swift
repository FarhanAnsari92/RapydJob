//
//  CreateJobViewController.swift
//  RapydJobs
//
//  Created by Maroof Khan on 03/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class CreateJobViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    lazy var vm: CreateJobViewModel = CreateJobViewModel(presenter: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create A Job"
        
        setup()
    }
    
    func setup() {
        tableView.dataSource = vm.datasource
        tableView.delegate = vm.delegate
    }
}

extension CreateJobViewController: OptionsPresenter {
    func present<Option>(options: [Option], selected: (Int) -> Void) {

    }
}

extension CreateJobViewController: AlertPresenter {
    func presentOptions(selected: @escaping (String) -> Void) {
        let controller: RelatedFieldsViewController = .getInstance()
        let viewModel = RelatedFieldsViewModel(selected: selected)
        controller.viewModel = viewModel
        
        present(controller, animated: true, completion: nil)
    }
    
    func present(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}

extension CreateJobViewController: Initializable {
    static var storyboardName: String { return "CreateJob" }
}


