//
//  InterviewsViewController.swift
//  RapydJobs
//
//  Created by Maroof Khan on 15/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import Segmentio
import ObjectMapper
import JGProgressHUD

class InterviewsViewController: BaseViewController {
    @IBOutlet weak var segmentControl: Segmentio!    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyPlaceholderView: EmptyPlaceholderView!
    
    private let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        return hud
    }()
    
    var interviews: [InterviewModel] = [InterviewModel]()
    
    var toast: JYToast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toast = JYToast()
        title = "Interviews"
        
        registerCells(tableView: tableView)
        self.setupSegment()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
        
        let segmentArray = [SegmentioItem(title: "SCHEDULED",image: UIImage(named: "")),
                            SegmentioItem(title: "INTERVIEWED",image: UIImage(named: ""))];
        
        segmentControl.setup(content: segmentArray, style: SegmentioStyle.onlyLabel, options: segmentioOptions)
        
        //segmentControl.selectedSegmentioIndex = 0
        
        segmentControl.valueDidChange = { segmentio, segmentIndex in
            
//            if segmentIndex == 1 {
//
//                let interv = InterviewModel()
//                interv.date = "1-1-2018"
//
//                let sb = UIStoryboard(name: "Interview", bundle: nil)
//                let vc = sb.instantiateViewController(withIdentifier: "RescheduleInterviewViewControllerID") as! RescheduleInterviewViewController
//                vc.interviewModel = interv
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
            
            self.hud.dismiss(animated: true)
            self.interviews.removeAll()
            self.tableView.reloadData()
            self.emptyPlaceholderView.isHidden = true
            self.callAPI(type: segmentIndex == 0 ? "scheduled" : "interviewed")
//
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        segmentControl.selectedSegmentioIndex = 0
    }
    
    func callAPI(type: String) {
        hud.show(in: view)
        _ = APIClient.callAPI(request: .getInterView(type: type), onSuccess: { (dictionary) in
            self.hud.dismiss(animated: true)
            guard let interviewsDictArr = dictionary["data"] as? [[String:Any]] else {
                return
            }
            self.interviews = Mapper<InterviewModel>().mapArray(JSONArray: interviewsDictArr)
            self.tableView.reloadData()
            if self.interviews.count == 0 {
                self.showEmptyPlaceholderView()
            }
        }) { (errorDictionary, _) in
            self.hud.dismiss(animated: true)
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    func reject(interviewId: Int, row: Int) {
        print(interviewId)
        _ = APIClient.callAPI(request: APIClient.reject(interviewId: interviewId), onSuccess: { (dictionary) in
            print(dictionary)
            self.interviews.remove(at: row)
            self.tableView.reloadData()
            if self.interviews.count == 0 {
                self.showEmptyPlaceholderView()
            }
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    func updateInterview(interviewId: Int, row:Int) {
        var param = [String:Any]()
        param["interview_status"] = "interviewed"
        _ = APIClient.callAPI(request: APIClient.updateInterview(interviewId: interviewId, param: param), onSuccess: { (dictionary) in
            
            print(dictionary)
            self.interviews.remove(at: row)
            self.tableView.reloadData()
            if self.interviews.count == 0 {
                self.showEmptyPlaceholderView()
            }
            
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    private func showEmptyPlaceholderView() {
        // In case the message is asked to be different by PM/Client
        if self.segmentControl.selectedSegmentioIndex == 0 {
            self.emptyPlaceholderView.message.text = "You haven't scheduled meetings yet"
        } else {
            self.emptyPlaceholderView.message.text = "You haven't scheduled meetings yet"
        }
        self.emptyPlaceholderView.isHidden = false
    }
    
    private func registerCells(tableView: UITableView) {
        tableView.register(
            UINib(nibName: "ScheduledTableViewCell", bundle: .main),
            forCellReuseIdentifier: "scheduled-tableview")
        tableView.register(
            UINib(nibName: "InterviewedTableViewCell", bundle: .main),
            forCellReuseIdentifier: "interviewed-tableview")
    }
}

extension InterviewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.interviews.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentControl.selectedSegmentioIndex < 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "scheduled-tableview") as! ScheduledTableViewCell

            cell.updateInterviewCompletion = {
                guard let interviewId = self.interviews[indexPath.row].interviewId else {
                    return
                }
                self.updateInterview(interviewId: interviewId, row: indexPath.row)
            }
            
            cell.rescheduleInterviewCompletion = {
                let interv = self.interviews
                let sb = UIStoryboard(name: "Interview", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "RescheduleInterviewViewControllerID") as! RescheduleInterviewViewController
                vc.interviewModel = interv[indexPath.row]
                
                vc.completion = { () in
                    
                    self.interviews.removeAll()
                    self.tableView.reloadData()
                    self.callAPI(type: "scheduled")
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.profilePictureCompletion = {
                guard let userId = self.interviews[indexPath.row].userId else {
                        return
                }
                
                let profileDetailsVC = JobSeekerProfileViewController.getInstance()
                profileDetailsVC.jobseekerId = userId
                self.navigationController?.pushViewController(profileDetailsVC, animated: true)
            }
            
            cell.update(self.interviews[indexPath.row])
            
            cell.shouldDrawFullShadow = true
            //cell.setup(viewModel: cellVM)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "interviewed-tableview") as! InterviewedTableViewCell
            
            cell.makeOfferCompletion = {
                
                let interv = self.interviews
                
                let storyboard = UIStoryboard(name: "Offer", bundle: nil)
                let makeOfferVc = storyboard.instantiateViewController(withIdentifier: "MakeOfferViewControllerID") as! MakeOfferViewController
                
                makeOfferVc.jobId = interv[indexPath.row].jobId
                makeOfferVc.jobSeekerId = interv[indexPath.row].userId
                self.navigationController?.pushViewController(makeOfferVc, animated: true)
                
            }
            
            cell.rejectOfferCompletion = {
                guard let interviewId = self.interviews[indexPath.row].interviewId else {
                        return
                }
                self.reject(interviewId: interviewId, row: indexPath.row)
                
            }
            
            cell.profilePictureCompletion = {
                guard let userId = self.interviews[indexPath.row].userId else {
                        return
                }
                
                let profileDetailsVC = JobSeekerProfileViewController.getInstance()
                profileDetailsVC.jobseekerId = userId
                self.navigationController?.pushViewController(profileDetailsVC, animated: true)
                
                
            }
            
            cell.shouldDrawFullShadow = true
            cell.update(self.interviews[indexPath.row])
            //cell.setup(viewModel: cellVM)
            return cell
        }
    }
}

extension InterviewsViewController: UITableViewDelegate {
    
}

extension InterviewsViewController: Initializable {
    static var storyboardName: String {
        return UIStoryboard.Name.interviews.rawValue
    }
}
