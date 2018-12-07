//
//  HRVC.swift
//  RapydJobs
//
//  Created by Muhammad Khan on 16/10/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit

class HRVC: BaseViewController {
    
    @IBOutlet weak var tbl: UITableView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    private func setupViews() {
        
        self.tbl.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tbl.estimatedSectionHeaderHeight = 80
        self.tbl.register(UINib(nibName: "SettingsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        
        title = "HR"
    }
}

extension HRVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SettingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        cell.actionButton.setImage(UIImage(named: "ic_next"), for: .normal)
        if indexPath.section == 0 {
            cell.titleLabel.text = "Manage Your Employees"
        } else {
            if indexPath.row == 0 {
                cell.titleLabel.text = "View or Upload Cotracts"
            } else {
                cell.titleLabel.text = "Signed Contracts"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = Bundle.main.loadNibNamed("SettingsHeaderView", owner: self, options: nil)?.first as? SettingsHeaderView else {
            return UIView()
        }
        view.titleLabel.text = section == 0 ? "Manage Employees" : "Manage Contracts"
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "HR", bundle: nil)
        if indexPath.section == 0 {
            let vc = sb.instantiateViewController(withIdentifier: "ManageEmployeeViewControllerID") as! ManageEmployeeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if indexPath.row == 0 {
                let vc = sb.instantiateViewController(withIdentifier: "OrganizationContractViewControllerID") as! OrganizationContractViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                let vc = sb.instantiateViewController(withIdentifier: "SignedContractViewControllerID") as! SignedContractViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}

extension HRVC: Initializable {
    static var storyboardName: String {
        return UIStoryboard.Name.hr.rawValue
    }
}
