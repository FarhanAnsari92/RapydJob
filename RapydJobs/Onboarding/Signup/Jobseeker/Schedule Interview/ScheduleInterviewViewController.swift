//
//  ScheduleInterviewViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/8/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import ObjectMapper
import JGProgressHUD

class ScheduleInterviewViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyPlaceholderView: EmptyPlaceholderView! {
        didSet {
            self.emptyPlaceholderView.message.text = "You have no scheduled meetings yet"
        }
    }
    var jobOffers = [[String:Any]]()
    
    let limit = 10
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
        self.title = "Schedule Interviews"
        self.tableView.register(UINib(nibName: "ScheduleInterviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleInterviewTableViewCellID")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AppContainer.shared.notificationContainer.InterviewSchedule {
            Helper.changeRedDot(type: "interview");
        }
        AppContainer.shared.notificationContainer.save(InterviewSchedule: false)
        
        self.getInterviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func getInterviews() {
        hud.show(in: view)
        _ = APIClient.callAPI(request: .getJobseekerInterview(limit: self.limit, page: self.currentPage), onSuccess: { (dictionary) in
            self.hud.dismiss(animated: true)
            
            guard let rawData = dictionary["data"] as? [[String:Any]] else {
                return
            }
            print(rawData)
            let lastPage = dictionary["last_page"] as? Int ?? 0
            self.lastPage = lastPage + 1
            let currentPage = dictionary["current_page"] as! Int
            var arrOfObj = [[String:Any]]()
            for item in rawData {
                let date = item["date"] as! String
                let startTime = item["start_time"] as! String
                let endTime = item["end_time"] as! String
                let time = startTime + " - " + endTime
                
                var dic = [String:Any]()
                dic["date"] = date
                dic["time"] = time
                if let jobDetail = item["job_detail"] as? [String:Any],
                    let user = jobDetail["user"] as? [String:Any],
                    let title = jobDetail["title"] as? String,
                    let organizationPicture = user["profile_image"] as? String,
                    let organizationName = user["username"],
                    let jobId = item["job_id"] as? Int {
                    dic["title"] = title
                    dic["organizationPicture"] = organizationPicture
                    dic["organizationName"] = organizationName
                    dic["jobId"] = jobId
                }
                
                arrOfObj.append(dic)
            }
            if arrOfObj.count > 0 {
                self.currentPage += 1
            }
            self.jobOffers = arrOfObj
            self.tableView.reloadData()
            if self.jobOffers.count == 0 {
                self.emptyPlaceholderView.isHidden = false
            }
            
        }) { (errorDictionary, _) in
            self.hud.dismiss(animated: true)
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jobOffers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleInterviewTableViewCellID", for: indexPath) as! ScheduleInterviewTableViewCell
        cell.updateData(self.jobOffers[indexPath.row])
        
        cell.profilePictureCompletion = {
            
            guard let jobId = self.jobOffers[indexPath.row]["jobId"] as? Int else {
                return
            }
            
            let sb = UIStoryboard(name: "JobDetails", bundle: nil)
            let vc = sb.instantiateInitialViewController() as! JobDetailsViewController
            
            print(self.jobOffers[indexPath.row])
            
            
            vc.jobId = "\(jobId)"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            print("Load mare")
            self.isLoadMore = true
            if self.currentPage < lastPage, !self.isLoading {
                self.getInterviews()
            }
            
        }
    }

}

extension ScheduleInterviewViewController: Initializable {
    static var storyboardName: String {
        return UIStoryboard.Name.scheduleInterview.rawValue
    }
}
