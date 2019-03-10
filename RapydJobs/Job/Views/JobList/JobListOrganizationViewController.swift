//
//  JobListOrganizationViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 10/28/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import Segmentio
import ObjectMapper
import JGProgressHUD
import Alamofire

class JobListOrganizationViewController: BaseViewController {
    
    @IBOutlet weak var segmentControl: Segmentio!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyPlaceholderView: EmptyPlaceholderView!
    var jobs = [OrganizationJob]()
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
        self.title = "Jobs"
        
        self.tableView.register(UINib(nibName: "JobTableViewCell", bundle: nil), forCellReuseIdentifier: "JobTableViewCellID")
        self.tableView.register(UINib(nibName: "PreviousJobTableViewCell", bundle: nil), forCellReuseIdentifier: "PreviousJobTableViewCellID")
        
        self.setupSegment()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        segmentControl.selectedSegmentioIndex = 0
    }
    
    func setupSegment() {
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
        
        let segmentArray = [SegmentioItem(title: "ACTIVE",image: UIImage(named: "")),
                            SegmentioItem(title: "PREVIOUS",image: UIImage(named: ""))];
        
        segmentControl.setup(content: segmentArray, style: SegmentioStyle.onlyLabel, options: segmentioOptions)
        
        segmentControl.valueDidChange = { segmentio, segmentIndex in
            self.hud.dismiss(animated: true)
            
            self.currentPage = 1
            self.lastPage = 0
            self.isLoadMore = false
            self.isLoading = false
            self.emptyPlaceholderView.isHidden = true
            self.jobs.removeAll()
            self.getActiveJobs(type: segmentIndex == 0 ? "active" : "previous")
        }
    }
    
    func getActiveJobs(type: String) {
        let limit = 10
        let type = type
        
        let params: Parameters = ["page": self.currentPage]
        self.isLoading = true
        hud.show(in: view)
        _ = APIClient.callAPI(request: APIClient.organizationJobsLists(limit: limit, type: type, page: params), onSuccess: { (dictionary) in
            print(dictionary)
            self.hud.dismiss(animated: true)
            self.isLoading = false
            
            let lastPage = dictionary["last_page"] as? Int ?? 0
            
            self.lastPage = lastPage + 1
            
            guard let data = dictionary["data"] as? [[String:Any]] else {
                return
            }
            
            let job = Mapper<OrganizationJob>().mapArray(JSONArray: data)
            if job.count > 0 {
                self.currentPage += 1
                
                if self.isLoadMore {
                    for item in job {
                        self.jobs.append(item)
                    }
                } else {
                    self.jobs = job
                }
            }
            
            self.tableView.reloadData()
            
            if self.jobs.count == 0{
                self.showEmptyPlaceholderView()
            }
            
        }) { (errorDictionary, _) in
            self.isLoading = false
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
            self.hud.dismiss(animated: true)
        }
    }
    
    private func showEmptyPlaceholderView() {
        if self.segmentControl.selectedSegmentioIndex == 0 {
            self.emptyPlaceholderView.message.text = "You have no active jobs at this time"
        } else if self.segmentControl.selectedSegmentioIndex == 1 {
            self.emptyPlaceholderView.message.text = "You have no previous jobs at this time"
        }
        self.emptyPlaceholderView.isHidden = false
    }
    
    func deleteJob(id: Int, row: Int) {
        hud.show(in: view)
        _ = APIClient.callAPI(request: APIClient.deleteJob(id: id), onSuccess: { (dictionary) in
            self.hud.dismiss(animated: true)
            self.jobs.remove(at: row)
            if self.jobs.count == 0{
                self.showEmptyPlaceholderView()
            }
            self.tableView.reloadData()
        }, onFailure: { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
            self.hud.dismiss(animated: true)
            print(errorDictionary)
        })
    }
    
    func changeJobStatus(id: Int, row: Int, param: [String:Any]) {
        hud.show(in: view)
        _ = APIClient.callAPI(request: APIClient.updateJob(id: id, param: param), onSuccess: { (dictionary) in
            self.hud.dismiss(animated: true)
            self.jobs.remove(at: row)
            if self.jobs.count == 0{
                self.showEmptyPlaceholderView()
            }
            self.tableView.reloadData()
        }) { (errorDictionary, _) in
            self.hud.dismiss(animated: true)
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
        
    }
    
}

extension JobListOrganizationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            print("Load mare")
            self.isLoadMore = true
            if self.currentPage < lastPage, !self.isLoading {
                self.getActiveJobs(type: self.segmentControl.selectedSegmentioIndex == 0 ? "active" : "previous")
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentControl.selectedSegmentioIndex < 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobTableViewCellID", for: indexPath) as! JobTableViewCell
            cell.jobTitle.text = self.jobs[indexPath.row].title
            cell.editJobCompletion = {
                let storyboard = UIStoryboard(name: "CreateJob", bundle: nil)
                let updateJobVC = storyboard.instantiateViewController(withIdentifier: "UpdateJobViewControllerID") as! UpdateJobViewController
                updateJobVC.organizationJob = self.jobs[indexPath.row]
                updateJobVC.delegate = self
                self.navigationController?.pushViewController(updateJobVC, animated: true)
            }
            cell.stopJobCompletion = {
                self.changeJobStatus(id: self.jobs[indexPath.row].id, row: indexPath.row, param: ["status" : "previous"])
            }
            return cell
        
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousJobTableViewCellID", for: indexPath) as! PreviousJobTableViewCell
            cell.jobTitle.text = self.jobs[indexPath.row].title
            
            cell.deleteJobCompletion = {
                AlertService.shared.alert(in: self, "Are you sure you want to delete this job?", success: {
                    self.deleteJob(id: self.jobs[indexPath.row].id, row: indexPath.row)
                })
                
            }
            
            cell.repeatJobCompletion = {
                self.changeJobStatus(id: self.jobs[indexPath.row].id, row: indexPath.row, param: ["status" : "active"])
            }
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.jobs[indexPath.row].toJSON())
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

extension JobListOrganizationViewController: UpdateJobViewControllerDelegate {
    func didUpdate(job: OrganizationJob) {
        self.currentPage = 1
        self.lastPage = 0
        self.isLoadMore = false
        self.isLoading = false
        self.getActiveJobs(type: self.segmentControl.selectedSegmentioIndex == 0 ? "active" : "previous")
    }
}

extension JobListOrganizationViewController: Initializable {
    static var storyboardName: String {
        return UIStoryboard.Name.jobList.rawValue
    }
}

