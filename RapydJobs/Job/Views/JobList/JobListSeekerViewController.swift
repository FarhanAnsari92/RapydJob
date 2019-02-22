//
//  JobListSeekerViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 10/28/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import Segmentio
import ObjectMapper
import JGProgressHUD

class JobListSeekerViewController: BaseViewController {

    @IBOutlet weak var segmentControl: Segmentio!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyPlaceholderView: EmptyPlaceholderView!
    var jobOffers = [JobOfferData]()
    
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
        self.title = "Job Offers"
        self.tableView.register(UINib(nibName: "JobOfferTableViewCell", bundle: nil), forCellReuseIdentifier: "JobOfferTableViewCellID")
        self.setupSegment()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        segmentControl.selectedSegmentioIndex = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setupSegment() {
        let segmentioOptions = SegmentioOptions(
            backgroundColor: .white,
            segmentPosition: .fixed(maxVisibleItems: 3),
            scrollEnabled: true,
            indicatorOptions: SegmentioIndicatorOptions(type: .bottom, ratio: 1, height: 1.5, color: UIColor(red: 97 / 255, green: 191 / 255, blue: 216 / 255, alpha: 1.0)),
            horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions(type: .none, height: 0.0, color: UIColor.clear),
            verticalSeparatorOptions: SegmentioVerticalSeparatorOptions(ratio: 0.0, color: UIColor.clear),
            imageContentMode: .center,
            labelTextAlignment: .center,
            segmentStates: SegmentioStates(
                defaultState: SegmentioState(
                    backgroundColor: .clear,
                    titleFont: UIFont.systemFont(ofSize: 11.0),
                    titleTextColor: .lightGray
                ),
                selectedState: SegmentioState(
                    backgroundColor: .clear,
                    titleFont: UIFont.systemFont(ofSize: 11.0),
                    titleTextColor: UIColor(red: 97 / 255, green: 191 / 255, blue: 216 / 255, alpha: 1.0)
                ),
                highlightedState: SegmentioState(
                    backgroundColor: .clear,
                    titleFont: UIFont.systemFont(ofSize: 11.0),
                    titleTextColor: .lightGray
                )
            )
        )
        
        let segmentArray = [SegmentioItem(title: "HIRED",image: UIImage(named: "")),
                            SegmentioItem(title: "PENDING",image: UIImage(named: "")),
                            SegmentioItem(title: "UNSUCCESSFUL",image: UIImage(named: ""))];
        
        segmentControl.setup(content: segmentArray, style: SegmentioStyle.onlyLabel, options: segmentioOptions)
        
        segmentControl.valueDidChange = { segmentio, segmentIndex in
            self.hud.dismiss(animated: true)
            
            self.currentPage = 1
            self.lastPage = 0
            self.isLoadMore = false
            self.isLoading = false
            self.emptyPlaceholderView.isHidden = true
            self.jobOffers.removeAll()
            if segmentIndex == 0 {
                self.getOffers(type: "active")
            } else if segmentIndex == 1 {
                self.getOffers(type: "pending")
            } else {
                self.getOffers(type: "reject")
            }
            
        }
    }
    
    func getOffers(type: String) {
        self.isLoading = true
        hud.show(in: view)
        _ = APIClient.callAPI(request: .getJobOffers(type: type, limit: self.limit, page: self.currentPage), onSuccess: { (dictionary) in
            self.isLoading = false
            self.hud.dismiss(animated: true)
            
            let lastPage = dictionary["last_page"] as? Int ?? 0
            
            self.lastPage = lastPage + 1
            
            guard let rawData = dictionary["data"] as? [[String:Any]] else {
                return
            }
            
            let offer = Mapper<JobOfferData>().mapArray(JSONArray: rawData)
            if offer.count > 0 {
                self.currentPage += 1
                
                if self.isLoadMore {
                    for item in offer {
                        self.jobOffers.append(item)
                    }
                } else {
                    self.jobOffers = offer
                }
            }
            self.tableView.reloadData()
            
            if self.jobOffers.count == 0 {
                self.showEmptyPlaceholderView()
            }
            
            
        }) { (errorDictionary, _) in
            self.isLoading = true
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
            self.hud.dismiss(animated: true)
            print(errorDictionary)
        }
    }
    
    private func showEmptyPlaceholderView() {
        if self.segmentControl.selectedSegmentioIndex == 0 {
            self.emptyPlaceholderView.message.text = "You have no job offers at this time"
        } else if self.segmentControl.selectedSegmentioIndex == 1 {
            self.emptyPlaceholderView.message.text = "You have no pending job offers at this time"
        } else {
            self.emptyPlaceholderView.message.text = "You have no unsuccessfull job offers at this time"
        }
        self.emptyPlaceholderView.isHidden = false
    }
    
}

extension JobListSeekerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            print("Load mare")
            self.isLoadMore = true
            if self.currentPage < lastPage, !self.isLoading {
                var type = ""
                if segmentControl.selectedSegmentioIndex == 0 {
                    type = "active"
                } else if segmentControl.selectedSegmentioIndex == 1 {
                    type = "pending"
                } else {
                    type = "reject"
                }
                self.getOffers(type: type)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jobOffers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobOfferTableViewCellID", for: indexPath) as!JobOfferTableViewCell
        if segmentControl.selectedSegmentioIndex == 0 {
            cell.separator.isHidden = false
            cell.makeTimesheet.isHidden = false
            cell.accept.isHidden = true
            cell.reject.isHidden = true
        } else if segmentControl.selectedSegmentioIndex == 1 {
            cell.separator.isHidden = false
            cell.makeTimesheet.isHidden = true
            cell.accept.isHidden = false
            cell.reject.isHidden = false
        } else {
            cell.separator.isHidden = true
            cell.makeTimesheet.isHidden = true
            cell.accept.isHidden = true
            cell.reject.isHidden = true
        }
        cell.timeSheetCompletion = {
            print("time sheet")
        }
        cell.acceptCompletion = {
            print("accept")
            self.acceptOffer(status: "active", row: indexPath.row)
        }
        cell.rejectCompletion = {
            print("reject")
            self.acceptOffer(status: "reject", row: indexPath.row)
        }
        cell.profilePictureCompletion = {
            guard let jobId = self.jobOffers[indexPath.row].id else {
                return
            }
            
            let sb = UIStoryboard(name: "JobDetails", bundle: nil)
            let vc = sb.instantiateInitialViewController() as! JobDetailsViewController
            
            print(self.jobOffers[indexPath.row].toJSON())
            
            
            vc.jobId = "\(jobId)"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        cell.updateData(self.jobOffers[indexPath.row])
        return cell
    }
    
    func acceptOffer(status: String, row: Int) {
        var param = [String:Any]()
        param["status"] = status
        param["joboffer_id"] = self.jobOffers[row].jobOfferId
        print(param)
        hud.show(in: view)
        _ = APIClient.callAPI(request: .acceptJoboffer(param: param), onSuccess: { (dictionary) in
            self.hud.dismiss(animated: true)
            print(dictionary)
            self.jobOffers.remove(at: row)
            if self.jobOffers.count == 0 {
                self.showEmptyPlaceholderView()
            }
            self.tableView.reloadData()
            
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
            self.hud.dismiss(animated: true)
            print(errorDictionary)
        }
    }
    /*
     @Headers({"Accept: application/json", "Content-Type: application/json"})
     @POST("accept-joboffer")
     Call<RespondJobOfferResponse> respondJobOffer(@Body JsonObject body);
     
     JsonObject paramObject = new JsonObject();
     paramObject.addProperty("joboffer_id", data.getJobOfferId());
     paramObject.addProperty("status", status);
     status => {active, reject}
     */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension JobListSeekerViewController: Initializable {
    static var storyboardName: String {
        return UIStoryboard.Name.jobList.rawValue
    }
}
