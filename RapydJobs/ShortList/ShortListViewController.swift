//
//  ShortListViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 10/29/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import Koloda
import ObjectMapper

class ShortListViewController: BaseViewController {
    
    @IBOutlet weak var cardView: KolodaView!
    @IBOutlet weak var jobSelectorButton: JobPickerButton!
    
    var jobs = [JobList]()
    var selectedJob: JobList?
    var cardData = [[String:Any]]()

    var toast: JYToast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toast = JYToast()
        
        self.cardView.countOfVisibleCards = 3
        self.cardView.delegate = self
        self.cardView.dataSource = self
        self.cardView.reloadData()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Shortlisted"
        if AppContainer.shared.user.user?.accountType == "organization" {
            self.getDropDownData();
            self.jobSelectorButton.isHidden = false
        } else {
            self.jobSelectorButton.isHidden = true
            self.getSeekerShortListData()
        }
        
    }
    
//    fileprivate func refreshData() {
//        if AppContainer.shared.user.user?.accountType == "organization" {
//            self.getOrganizationShortListedData(job: self.selectedJob!)
//        } else {
//            self.getSeekerShortListData()
//        }
//    }
//
    func getDropDownData() {
        _ = APIClient.callAPI(request: .dropDown, onSuccess: { (dictionary) in
            if let arr = dictionary["data"] as? [[String:Any]] {
                self.jobs = Mapper<JobList>().mapArray(JSONArray: arr)
                
                if self.jobs.count > 0 {
                    self.selectedJob = self.jobs.first
                    self.getOrganizationShortListedData(job: self.jobs.first!)
                    self.jobSelectorButton.setTitle((self.jobs.first)?.title, for: .normal)
                } else {
                    self.toast.isShow("No Jobs Found")
                }
            }
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    func getOrganizationShortListedData(job: JobList) {
        _ = APIClient.callAPI(request: .getShortListedJobSeeker(endPoint: job.id), onSuccess: { (dictionary) in
            print(dictionary)
            guard let arr = dictionary["data"] as? [[String:Any]] else {
                return
            }
            self.cardData = arr
            
            self.cardView.resetCurrentCardIndex()
            self.cardView.reloadData()
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    func getSeekerShortListData() {
        _ = APIClient.callAPI(request: .getShortListedOrganization, onSuccess: { (dictionary) in
            print(dictionary)
            guard let arr = dictionary["data"] as? [[String:Any]] else {
                return
            }
            self.cardData = arr
            self.cardView.resetCurrentCardIndex()
            self.cardView.reloadData()
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    @IBAction func didTapJobPickerButton(_ sender: Any) {
        
        if jobs.count > 0 {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            for i in 0..<jobs.count {
                actionSheet.addAction(UIAlertAction(title: jobs[i].title, style: .default, handler: { [weak self](action) in
                    self?.jobSelectorButton.setTitle(self?.jobs[i].title, for: .normal)
                    self?.selectedJob = self?.jobs[i]
                    self?.getOrganizationShortListedData(job: (self?.jobs[i])!)
                    actionSheet.dismiss(animated: true, completion: nil)
                }))
            }
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func superLike(data: [String:Any], index: Int) {
        
        if AppContainer.shared.user.user?.accountType == "organization" {
            self.organizationSuperLike(data: data, index: index)
        } else {
            self.seekerSuperLike(data: data, index: index)
        }
    }
    
    func seekerSuperLike(data: [String:Any], index: Int) {
        
        guard let jobId = data["id"] as? Int else {
            return
        }
        var param = [String:Any]()
        param["job_id"] = jobId
        param["type"] = "Job"
        param["like"] = "yes"
        
        _ = APIClient.callAPI(request: APIClient.superlikeJobSeekerRequest(param: param), onSuccess: { (dictionary) in
            
            if index == self.cardData.count - 1 {
                self.cardData.removeAll()
                self.cardView.resetCurrentCardIndex()
                self.cardView.reloadData()
            }
            
            guard let superlikeResponse = Mapper<OrganizationSuperLikeResponse>().map(JSON: dictionary),
                let conversationId = superlikeResponse.conversationId else {
                    return
            }
            
            let sb = UIStoryboard(name: "Chat", bundle: nil)
            let chatVC = sb.instantiateViewController(withIdentifier: "ChatMessagesVC") as! ChatMessagesVC
            
//            guard let jobSeeker = data["job_seeker"] as? [String:Any],
//                let id = jobSeeker["user_id"] as? String else {
//                    return
//            }
            let fullName = data["organization_name"] as? String ?? "N/A"
            let jobTitle = data["title"] as? String ?? "N/A"
            
            chatVC.seekerName = fullName
            chatVC.seekerPicture = data["profile_image"] as? String ?? ""
            chatVC.title = fullName
            
           // chatVC.jobSeekerId = Int(id)
            chatVC.conversationId = conversationId
            chatVC.jobId = jobId
            chatVC.jobTitle = jobTitle
            
            self.navigationController?.pushViewController(chatVC, animated: true)

        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    func organizationSuperLike(data: [String:Any], index: Int) {
        
        guard let id = data["id"] as? Int else {
                return
        }
        var params = [String: Any]()
        params["user_id"] = id
        params["job_id"] = self.selectedJob?.id
        params["type"] = "User"
        params["like"] = "yes"
        _ = APIClient.callAPI(request: APIClient.superLikeEmployerRequest(param: params), onSuccess: { (dictionary) in
            
            if index == self.cardData.count - 1 {
                self.cardData.removeAll()
                self.cardView.resetCurrentCardIndex()
                self.cardView.reloadData()
            }
            
            let superlikeResponse = Mapper<OrganizationSuperLikeResponse>().map(JSON: dictionary)
            
            let sb = UIStoryboard(name: "Chat", bundle: nil)
            let chatVC = sb.instantiateViewController(withIdentifier: "ChatMessagesVC") as! ChatMessagesVC
            
            let jobSeekerId = superlikeResponse!.jobseekerId as? Int
            chatVC.jobSeekerId = jobSeekerId
            chatVC.conversationId = superlikeResponse?.conversationId
            chatVC.jobTitle = self.selectedJob?.title
            chatVC.jobId = self.selectedJob?.id
            guard let jobSeeker = data["job_seeker"] as? [String:Any],
                let id = jobSeeker["user_id"] as? String,
                let fullName = jobSeeker["fullname"] as? String else {
                    return
            }
            guard let jobSeekerImage = data["profile_image"] as? String else {
                return
            }
            chatVC.seekerName = fullName
            chatVC.seekerPicture = jobSeekerImage
            chatVC.title = fullName
            
            chatVC.jobSeekerId = Int(id)
            chatVC.conversationId = superlikeResponse?.conversationId
            chatVC.jobId = self.selectedJob?.id
            chatVC.title = fullName
            chatVC.seekerPicture = data["profile_image"] as? String
            
            self.navigationController?.pushViewController(chatVC, animated: true)
            
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
        
    }
    
    func likeJob(data: [String:Any], isLike: Bool, index: Int) {
        
        guard let jobId = data["id"] as? Int else {
            return
        }
        var param = [String:Any]()
        param["job_id"] = jobId
        param["type"] = "Job"
        param["like"] = isLike ? "yes" : "no"
        print(param)
        _ = APIClient.callAPI(request: APIClient.likeJobRequest(param: param), onSuccess: { (dictionary) in
            
            if index == self.cardData.count - 1 {
                self.cardData.removeAll()
                self.cardView.resetCurrentCardIndex()
                self.cardView.reloadData()
            }
            
            if isLike {
                print(dictionary)
                let superlikeResponse = Mapper<OrganizationSuperLikeResponse>().map(JSON: dictionary)
                
                guard let conversationId = superlikeResponse?.conversationId else {
                    return
                }
                
                let sb = UIStoryboard(name: "Chat", bundle: nil)
                let chatVC = sb.instantiateViewController(withIdentifier: "ChatMessagesVC") as! ChatMessagesVC
                
//                guard let jobSeeker = data["job_seeker"] as? [String:Any],
//                    let id = jobSeeker["user_id"] as? String else {
//                        return
//                }
                let fullName = data["organization_name"] as? String ?? "N/A"
                let jobTitle = data["title"] as? String ?? "N/A"
                
                chatVC.seekerName = fullName
                chatVC.seekerPicture = data["profile_image"] as? String ?? ""
                chatVC.title = fullName
                
                //chatVC.jobSeekerId = Int(id)
                chatVC.conversationId = conversationId
                chatVC.jobId = jobId
                chatVC.jobTitle = jobTitle
                
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
            
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    func likeSeeker(data: [String:Any], isLike: Bool, index: Int) {
        
        guard let id = data["id"] as? Int else {
            return
        }
        var params = [String: Any]()
        params["job_id"] = self.selectedJob?.id
        params["type"] = "User"
        params["like"] = isLike ? "yes" : "no"
        params["user_id"] = id
        
        _ = APIClient.callAPI(request: .likeEmployeeRequest(param: params), onSuccess: { (dictionary) in
            
            if index == self.cardData.count - 1 {
                self.cardData.removeAll()
                self.cardView.resetCurrentCardIndex()
                self.cardView.reloadData()
            }
            
            if isLike {
                
                let superlikeResponse = Mapper<OrganizationSuperLikeResponse>().map(JSON: dictionary)
                
                guard let conversationId = superlikeResponse?.conversationId else {
                    return
                }
                
                let sb = UIStoryboard(name: "Chat", bundle: nil)
                let chatVC = sb.instantiateViewController(withIdentifier: "ChatMessagesVC") as! ChatMessagesVC
                
                guard let jobSeeker = data["job_seeker"] as? [String:Any],
                    let id = jobSeeker["user_id"] as? String else {
                        return
                }
                let fullName = jobSeeker["fullname"] as? String ?? "N/A"
                
                chatVC.seekerName = fullName
                chatVC.seekerPicture = data["profile_image"] as? String ?? ""
                chatVC.title = fullName
                
                chatVC.jobSeekerId = Int(id)
                chatVC.conversationId = conversationId
                chatVC.jobId = self.selectedJob?.id
                chatVC.jobTitle = self.selectedJob?.title
                
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    @IBAction func like(_ sender: UIButton) {
        self.cardView.swipe(.right)
    }
    
    @IBAction func disLike(_ sender: UIButton) {
        self.cardView.swipe(.left)
    }
    
    @IBAction func superLike(_ sender: UIButton) {
        self.cardView.swipe(.down)
    }
    
}

extension ShortListViewController: KolodaViewDelegate, KolodaViewDataSource {
    
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        if self.cardData.count == 0 {
            return false
        }
        return true
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        if self.cardData.count > 0 {
            if AppContainer.shared.user.user?.accountType ?? "" == "jobseeker" {
                let sb = UIStoryboard(name: "JobDetails", bundle: nil)
                let vc = sb.instantiateInitialViewController() as! JobDetailsViewController
                let card = self.cardData[index]
                vc.rawItem = card
                
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let profileDetailsVC = JobSeekerProfileViewController.getInstance()
                print(cardData[index])
                profileDetailsVC.jobseekerId = cardData[index]["id"] as? Int
                self.navigationController?.pushViewController(profileDetailsVC, animated: true)
            }
        }
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        guard self.cardData.count > 0 else {
            self.cardView.reloadData()
            return
        }
        let cardItem = self.cardData[index]
        switch direction {
        case .right:
            if AppContainer.shared.user.user?.accountType == "organization" {
                self.likeSeeker(data: cardItem, isLike: true, index: index)
            } else {
                self.likeJob(data: cardItem, isLike: true, index: index)
            }
        
        case .left:
            if AppContainer.shared.user.user?.accountType == "organization" {
                self.likeSeeker(data: cardItem, isLike: false, index: index)
            } else {
                self.likeJob(data: cardItem, isLike: false, index: index)
            }
            
        case .down:
            self.superLike(data: cardItem, index: index)
        default:
            break
        }
        
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right, .down]
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CardOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
    
    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        
        let currentVisibleIndex = koloda.currentCardIndex
        let nextIndex = currentVisibleIndex + 1
        if nextIndex < cardData.count {
            var cardItem = self.cardData[nextIndex]
            cardItem["shouldHide"] = false
            guard let view = koloda.viewForCard(at: nextIndex) as? CardViewCell else {return}
            view.populateWithCardItem(cardItem)
        }
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        guard let view = Bundle.main.loadNibNamed("CardViewCell", owner: self, options: nil)?.first as? CardViewCell else {
            return UIView()
        }
        
        if cardData.count > 0 {
            var cardItem = cardData[index]
            cardItem["shouldHide"] = index == 0 ? false : true
            view.noDataLabel.isHidden = true
            view.populateWithCardItem(cardItem)
        } else {
            let cardItem = CardViewItem()
            cardItem.shouldHide = true
            view.populateWithCardItem(cardItem)
        }
        
        view.shidTimingCompletion = {
            
            var dateArray = [[String: Any]]()
            if AppContainer.shared.user.user?.accountType == "organization" {
                let jobseeker = self.cardData[index]["job_seeker"] as! [String: Any]
                dateArray = jobseeker["dates"] as? [[String: Any]] ?? [[String: Any]]()
            } else {
                dateArray = self.cardData[index]["dates"] as? [[String: Any]] ?? [[String: Any]]()
            }
            
            print(dateArray)
            
            if dateArray.count > 0 {
                
                var availabilityDtoArray = [AvailabilityDTO]()
                
                for item in dateArray {
                    
                    let startTime = item["start_time"] as? String ?? ""
                    let endTime = item["end_time"] as? String ?? ""
                    let day = item["day"] as? String ?? ""
                    
                    let availabilityDto = AvailabilityDTO(day: day, startTime: startTime, endTime: endTime)
                    availabilityDtoArray.append(availabilityDto)
                }
                
                let sb = UIStoryboard(name: "Timesheet", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "ShowTimeSheetViewControllerID") as! ShowTimeSheetViewController
                vc.dates = availabilityDtoArray
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        
        return view
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        if self.cardData.count == 0 {
            return 1
        }
        return cardData.count
    }
}

extension ShortListViewController: Initializable {
    static var storyboardName: String {
        return "ShortList"
    }
}
