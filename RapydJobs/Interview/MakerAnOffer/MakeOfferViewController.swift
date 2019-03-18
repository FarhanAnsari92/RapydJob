//
//  MakeOfferViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/2/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import JGProgressHUD
import ObjectMapper

class MakeOfferViewController: UIViewController {
    
    @IBOutlet weak var tbl: UITableView!
    var contracts: [Contract] = [Contract]()
    @IBOutlet weak var emptyPlaceholderView: EmptyPlaceholderView!
    
    var currentPage = 1
    var lastPage = 0
    var isLoadMore: Bool = false
    var isLoading: Bool = false

    var jobId: Int!
    var jobSeekerId: Int!
    
    var toast: JYToast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toast = JYToast()
        self.emptyPlaceholderView.message.text = "You don't have any contract at this moment"
        self.setupView()
        self.getContracts()
    }
    
    private let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        return hud
    }()
    
    func setupView() {
        view.backgroundColor = Constants.Colors.primaryGreenColor
        self.title = "Make Offer"
        tbl.register(UINib(nibName: "MakeOfferTableViewCell", bundle: nil), forCellReuseIdentifier: "MakeOfferTableViewCellID")
    }
    
    func getContracts() {
        // Loader
        self.isLoading = true
        hud.show(in: view)
        _ = APIClient.callAPI(request: .getContracts(page: self.currentPage), onSuccess: { (dictionary) in
            self.isLoading = false
            self.hud.dismiss(animated: true)
            
            let lastPage = dictionary["last_page"] as? Int ?? 0
            
            self.lastPage = lastPage + 1
            
            guard let contractRawData = dictionary["data"] as? [[String:Any]] else {
                return
            }
            
            let contract = Mapper<Contract>().mapArray(JSONArray: contractRawData)
            if contract.count > 0 {
                self.currentPage += 1
            }
            
            if self.isLoadMore {
                for item in contract {
                    self.contracts.append(item)
                }
            } else {
                self.contracts = contract
            }
            
            self.emptyPlaceholderView.isHidden = self.contracts.count > 0
            self.tbl.reloadData()
            
        }) { (errorDictionary, _) in
            self.isLoading = false
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
            self.hud.dismiss(animated: true)
            print(errorDictionary)
        }
    }
    
    func callApi(contractId: Int) {
        var params = [String:Any]()
        params["job_id"] = jobId
        params["jobseeker_id"] = jobSeekerId
        params["contract_id"] = contractId
        params["status"] = "pending"
        
        
        hud.show(in: view)
        _ = APIClient.callAPI(request: .makeOffer(param: params), onSuccess: { (dictionary) in
            self.hud.dismiss(animated: true)
            self.toast.isShow("Offer made successfully")
            self.navigationController?.popViewController(animated: true)
            print(dictionary)
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
            self.hud.dismiss(animated: true)            
        }
    }
}

extension MakeOfferViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            print("Load mare")
            self.isLoadMore = true
            if self.currentPage < lastPage, !self.isLoading {
                self.getContracts()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contracts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MakeOfferTableViewCellID", for: indexPath) as! MakeOfferTableViewCell
        cell.updateData(date: self.contracts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let sendBtn = UIAlertAction(title: "Send", style: UIAlertActionStyle.default) { (action) in
            guard let contractId = self.contracts[indexPath.row].contractId else {
                return
            }
            self.callApi(contractId: contractId)
        }
        
        actionSheet.addAction(sendBtn)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
