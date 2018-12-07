//
//  SideMenuMainViewController.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuMainViewController: UIViewController {
    
    @IBOutlet weak var profilePictureIV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: SideMenuTableViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        viewModel = SideMenuTableViewModel()
        
        // Setting table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "SideMenuTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        tableView.rowHeight = 50

        // Adding gradient of 20%
        addGradient(withRatio: 0.2)
        
        if AppContainer.shared.user.user?.accountType == "organization" {
            self.profilePictureIV.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapProfilePicture))
            self.profilePictureIV.addGestureRecognizer(tapGesture)
        }
        
    }
    
    @objc func didTapProfilePicture() {
        EditProfileFlowManager.shared().isEditProfile = true
        
        let sb = UIStoryboard(name: "EmployerSignup", bundle: nil)
        EditProfileFlowManager.shared().isEditProfile = true
        let vc = sb.instantiateViewController(withIdentifier: "EmployerSignupOneVC") as! EmployerSignupOneVC
        
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = AppContainer.shared.user.user else {
            return
        }
        self.nameLabel.text = user.userName
        self.subtitleLabel.text = user.organization?.registrationNumber ?? ""
        if let profileImage = user.profileImage {
            self.profilePictureIV.setImageWithName(profileImage)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profilePictureIV.layer.cornerRadius = profilePictureIV.bounds.size.width/2
        profilePictureIV.layer.masksToBounds = true
    }
}

extension SideMenuMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell:SideMenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SideMenuTableViewCell else { return UITableViewCell() }
        cell.sideMenuItem = viewModel.data[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = viewModel.data[indexPath.row].viewController
        if (self.navigationController?.topViewController != vc) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
