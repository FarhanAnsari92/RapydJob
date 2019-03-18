//
//  OrganizationContractViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/9/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import JGProgressHUD
import ObjectMapper
import SwiftWebVC

class OrganizationContractViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var contracts: [Contract] = [Contract]()
    @IBOutlet weak var emptyPlaceholderView: EmptyPlaceholderView!
    
    var currentPage = 1
    var lastPage = 0
    var isLoadMore: Bool = false
    var isLoading: Bool = false
    
    private let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        return hud
    }()

    var toast: JYToast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toast = JYToast()        
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lastPage = 0
        self.currentPage = 0
        self.getContracts()
    }
    
    func setupView() {
        view.backgroundColor = Constants.Colors.primaryGreenColor
        self.title = "Contracts"
        self.emptyPlaceholderView.message.text = "You don't have any contract at this moment"
        tableView.register(UINib(nibName: "ContractTableViewCell", bundle: nil), forCellReuseIdentifier: "ContractTableViewCellID")
    }
    
    @IBAction func addContract(_ sender: UIButton) {
        let sb = UIStoryboard(name: "HR", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddContractViewControllerID") as! AddContractViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
                
                if self.isLoadMore {
                    for item in contract {
                        self.contracts.append(item)
                    }
                } else {
                    self.contracts = contract
                }
            }
            self.emptyPlaceholderView.isHidden = self.contracts.count > 0
            self.tableView.reloadData()
            
        }) { (errorDictionary, _) in
            self.isLoading = false
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
            self.hud.dismiss(animated: true)
            print(errorDictionary)
        }
    }
    
    func deleteContract(contract: Contract, row: Int) {
        hud.show(in: view)
        _ = APIClient.callAPI(request: .deleteContract(contractId: contract.contractId), onSuccess: { (dictionary) in
            self.hud.dismiss(animated: true)
            self.contracts.remove(at: row)
            self.emptyPlaceholderView.isHidden = self.contracts.count > 0
            self.tableView.reloadData()
        }) { (errorDictionary, _) in
            self.hud.dismiss(animated: true)
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
}

extension OrganizationContractViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContractTableViewCellID", for: indexPath) as! ContractTableViewCell
        
        cell.deleteCompletion = {
            AlertService.shared.alert(in: self, "Are you sure you want to delete this contract?", success: {
                self.deleteContract(contract: self.contracts[indexPath.row], row: indexPath.row)
            })
        }
        
        cell.updateData(date: self.contracts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contract = self.contracts[indexPath.row]
        //self.viewContract(contract: contract) // Currently commenting this code as i don't know the contract URL, when i come to know than just uncomment this line
    }
    
    func viewContract(contract: Contract) {
        
        print(contract.toJSON())
        guard let fileName = contract.fileName else {
            AlertService.shared.alert(in: self, "No Contract Found")
            return
        }
        
        let baseurl = "http://ec2-18-191-9-134.us-east-2.compute.amazonaws.com/RapydJobs/storage/cv/\(fileName)"

        let webVC = SwiftModalWebVC(urlString: baseurl)
        self.present(webVC, animated: true, completion: nil)
        
    }
}
