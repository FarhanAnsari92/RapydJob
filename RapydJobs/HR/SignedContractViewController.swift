//
//  SignedContractViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/4/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import JGProgressHUD
import ObjectMapper

class SignedContractViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var signedContract = [SignedContract]()
    
    var currentPage = 1
    var lastPage = 0
    var isLoadMore: Bool = false
    var isLoading: Bool = false

    var toast: JYToast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toast = JYToast()
        self.setupView()
        self.getSignedContracts()
    }
    
    private let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        return hud
    }()
    
    func setupView() {
        title = "Signed Contracts"
        view.backgroundColor = Constants.Colors.primaryGreenColor
        self.tableView.register(UINib(nibName: "SignedContractTableViewCell", bundle: nil), forCellReuseIdentifier: "SignedContractTableViewCellID")        
    }
    
    func getSignedContracts() {
        self.isLoading = true
        hud.show(in: view)
        _ = APIClient.callAPI(request: .getSignedContract(page: self.currentPage), onSuccess: { (dictionary) in
            self.isLoading = false
            self.hud.dismiss(animated: true)
            print(dictionary)
            
            let lastPage = dictionary["last_page"] as? Int ?? 0
            
            self.lastPage = lastPage + 1
            
            guard let arr = dictionary["data"] as? [[String:Any]] else {
                return
            }
            
            let contracts = Mapper<SignedContract>().mapArray(JSONArray: arr)
            
            if contracts.count > 0 {
                self.currentPage += 1
                
                if self.isLoadMore {
                    for item in contracts {
                        self.signedContract.append(item)
                    }
                } else {
                    self.signedContract = contracts
                }
            }
            
            self.tableView.reloadData()
            
        }) { (errorDictionary, _) in
            self.isLoading = false
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
            self.hud.dismiss(animated: true)
            print(errorDictionary)
        }
    }
}

extension SignedContractViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            print("Load mare")
            self.isLoadMore = true
            if self.currentPage < lastPage, !self.isLoading {
                self.getSignedContracts()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.signedContract.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignedContractTableViewCellID", for: indexPath) as! SignedContractTableViewCell
        cell.userProfileCompletion = {
            let userId = self.signedContract[indexPath.row].signedBy?.id
            Helper.openJobSeekerProfile(self, jobId: userId)
        }
        cell.updateData(self.signedContract[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
