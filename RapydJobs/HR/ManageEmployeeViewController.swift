//
//  ManageEmployeeViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/3/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import Segmentio
import JGProgressHUD
import ObjectMapper

class ManageEmployeeViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: Segmentio!
    @IBOutlet weak var tableView: UITableView!
    var employees = [ManagedEmployees]()
    @IBOutlet weak var emptyPlaceholderView: EmptyPlaceholderView!
    
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
        self.setupSegment()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.segmentControl.selectedSegmentioIndex = 0
    }
    
    func setupView() {
        title = "Manage Employees"
        view.backgroundColor = Constants.Colors.primaryGreenColor
    }
    
    func setupSegment() {
        self.tableView.register(UINib(nibName: "ManagedEmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: "ManagedEmployeeTableViewCellID")
        let segmentioOptions = SegmentioOptions(
            backgroundColor: .white,
            segmentPosition: .dynamic,
            scrollEnabled: true,
            indicatorOptions: SegmentioIndicatorOptions(type: .bottom, ratio: 1, height: 1.5, color: UIColor(red: 97 / 255, green: 191 / 255, blue: 216 / 255, alpha: 1.0)),
            horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions(type: .none, height: 0.0, color: UIColor.clear),
            verticalSeparatorOptions: SegmentioVerticalSeparatorOptions(ratio: 0.0, color: UIColor.clear),
            imageContentMode: .center,
            labelTextAlignment: .center,
            segmentStates: SegmentioStates(
                defaultState: SegmentioState(
                    backgroundColor: .clear,
                    titleFont: UIFont.systemFont(ofSize: 14.0),
                    titleTextColor: .lightGray
                ),
                selectedState: SegmentioState(
                    backgroundColor: .clear,
                    titleFont: UIFont.systemFont(ofSize: 14.0),
                    titleTextColor: UIColor(red: 97 / 255, green: 191 / 255, blue: 216 / 255, alpha: 1.0)
                ),
                highlightedState: SegmentioState(
                    backgroundColor: .clear,
                    titleFont: UIFont.systemFont(ofSize: 14.0),
                    titleTextColor: .lightGray
                )
            )
        )
        
        let segmentArray = [SegmentioItem(title: "CURRENT",image: UIImage(named: "")),
                            SegmentioItem(title: "PREVIOUS",image: UIImage(named: ""))];
        
        segmentControl.setup(content: segmentArray, style: SegmentioStyle.onlyLabel, options: segmentioOptions)
        
        //segmentControl.selectedSegmentioIndex = 0
        
        segmentControl.valueDidChange = { segmentio, segmentIndex in
            self.hud.dismiss(animated: true)
            self.emptyPlaceholderView.isHidden = true
            self.callAPI(type: segmentIndex == 0 ? "start" : "stop")
        }
    }
    
    func callAPI(type: String) {
        hud.show(in: view)
        _ = APIClient.callAPI(request: APIClient.getManagedEmployees(Status: type), onSuccess: { (dic) in
           self.hud.dismiss(animated: true)
            guard let rawData = dic["data"] as? [[String:Any]] else {
                return
            }
            self.employees.removeAll()
            self.employees = Mapper<ManagedEmployees>().mapArray(JSONArray: rawData)
            self.tableView.reloadData()
            if self.employees.count == 0 {
                self.showEmptyPlaceholderView()
            }
            
            
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
            self.hud.dismiss(animated: true)
            print(errorDictionary)
        }
    }
    
    func changeEmployeeStatus(emp: ManagedEmployees, row: Int) {
        var param = [String:Any]()
        if self.segmentControl.selectedSegmentioIndex == 0 {
            param["status"] = "stop"
        } else {
            param["status"] = "start"
        }
        hud.show(in: view)
        _ = APIClient.callAPI(request: APIClient.updateEmployee(hireId: emp.hireId!,param: param), onSuccess: { (dictionary) in
            self.hud.dismiss(animated: true)
            if self.segmentControl.selectedSegmentioIndex == 0 {
                _ = RatingPopup(completion: { (dictionary) in
                    self.sendReview(dic: dictionary, emp: emp, row: row)
                })
            } else {
                self.employees.remove(at: row)
                self.tableView.reloadData()
                if self.employees.count == 0 {
                    self.showEmptyPlaceholderView()
                }
            }
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
            self.hud.dismiss(animated: true)
            print(errorDictionary)
        }
    }
    
    func sendReview(dic: [String:Any], emp: ManagedEmployees, row: Int) {
        let review = dic["review"] as? String ?? ""
        let rateDouble = dic["rate"] as? Double ?? 0.0
        let rateString = String(format:"%.1f", rateDouble)
        var param = [String:Any]()
        param["review"] = review
        param["star"] = rateString
        param["to"] = emp.userId
        hud.show(in: view)
        _ = APIClient.callAPI(request: APIClient.sendReview(param: param), onSuccess: { (dictionary) in
            self.hud.dismiss(animated: true)
            self.employees.remove(at: row)
            self.tableView.reloadData()
            if self.employees.count == 0 {
                self.showEmptyPlaceholderView()
            }
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
            self.hud.dismiss(animated: true)
            print(errorDictionary)
        }
    }
    
    func deleteEmployee(hireId: Int, row: Int) {
        _ = APIClient.callAPI(request: APIClient.deleteHiredEmployee(hireId: hireId), onSuccess: { (dictionary) in
            print(dictionary)
            self.employees.remove(at: row)
            self.tableView.reloadData()
            if self.employees.count == 0 {
                self.showEmptyPlaceholderView()
            }
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    private func showEmptyPlaceholderView() {
//        if self.segmentControl.selectedSegmentioIndex == 0 {
//            self.emptyPlaceholderView.message.text = "You haven't hired any candidates yet"
//        } else {
//            self.emptyPlaceholderView.message.text = "You haven't any previous candidate yet"
//        }
        self.emptyPlaceholderView.message.text = "You haven't hired any candidates yet"
        self.emptyPlaceholderView.isHidden = false
    }
}

extension ManageEmployeeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManagedEmployeeTableViewCellID", for: indexPath) as! ManagedEmployeeTableViewCell
        cell.updateData(employee: self.employees[indexPath.row])
        cell.renewBtn.isHidden = self.segmentControl.selectedSegmentioIndex == 0
        cell.deleteBtn.isHidden = self.segmentControl.selectedSegmentioIndex == 0
        cell.terminateBtn.isHidden = !(self.segmentControl.selectedSegmentioIndex == 0)
        cell.deleteCompletion = {
            AlertService.shared.alert(in: self, "Are you sure you want to delete this employee?", success: {
                let hireId = self.employees[indexPath.row].hireId!
                self.deleteEmployee(hireId: hireId, row: indexPath.row)
            })
        }
        cell.renewCompletion = {
            self.changeEmployeeStatus(emp: self.employees[indexPath.row], row: indexPath.row)
        }
        cell.terminateCompletion = {
            self.changeEmployeeStatus(emp: self.employees[indexPath.row], row: indexPath.row)
        }
        cell.profileCompletion = {
            print("prifle")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
