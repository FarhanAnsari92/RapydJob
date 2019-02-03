//
//  CardViewController.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 23/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

enum CardFlow {
    case dashboard
    case shortlisted
}

class CardViewController: BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var acceptButton: CardButton!
    @IBOutlet weak var rejectButton: CardButton!
    @IBOutlet weak var shortlistButton: CardButton!
    @IBOutlet weak var starButton: CardButton!
    @IBOutlet weak var reloadButton: CardButton!
    @IBOutlet weak var jobSelectorButton: JobPickerButton!
    
    var cardVC: CardContainerViewController?
    var viewModel: CardFlowViewModel!
    var cardFlow: CardFlow = .dashboard
    var selectedJob: JobsDropDownItem?
    
    var toast: JYToast!
    var isLastActionDeleted: Bool = false
    
    let messageBadgeView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 15, height: 15)))
    var shouldShowMessageBadgeView: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toast = JYToast()
        self.messageBadgeView.layer.cornerRadius = 7.5
        self.messageBadgeView.backgroundColor = UIColor.red
        self.messageBadgeView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMessage), name: .messageNotificationName, object: nil)
    }
    
    @objc func didReceiveMessage() {
        if self.shouldShowMessageBadgeView {
            self.messageBadgeView.isHidden = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.shouldShowMessageBadgeView = true
        self.messageBadgeView.isHidden = !AppContainer.shared.notificationContainer.Chat
        //
        //These codes moved from didLoad to viewAppear
        viewModel = CardFlowViewModel(withFlow: cardFlow)
        
        self.title = viewModel.title()
        
        self.navigationItem.rightBarButtonItems = rightBarButtonItems()
        
        self.cardVC?.viewModel.service.getCardData()
        
        setupActionStack()
        //
        
        if let accountType = AppContainer.shared.user.user?.accountType {
            if accountType == "organization" {
                jobSelectorButton.isHidden = false
            } else {
                jobSelectorButton.isHidden = true
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CardViewSegue" {
            guard let cardVC = segue.destination as? CardContainerViewController else { return }
            self.cardVC = cardVC
            self.cardVC?.cardFlow = cardFlow
            self.cardVC?.delegate = self
        }
    }

    func setupActionStack() {
        if cardFlow == .shortlisted {
            shortlistButton.removeFromSuperview()
            reloadButton.removeFromSuperview()
        }
    }
    
    func rightBarButtonItems() -> [UIBarButtonItem] {

        let interviewBtn: UIButton = UIButton(type: UIButtonType.custom)
        interviewBtn.setImage(UIImage(named: "ic_interview")?.withRenderingMode(.alwaysOriginal), for: .normal)
        interviewBtn.addTarget(self, action: #selector(didTapInterviewButton), for: .touchUpInside)
        interviewBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let interviewBarBtn = UIBarButtonItem(customView: interviewBtn)
        
        let messageBtn: UIButton = UIButton(type: UIButtonType.custom)
        messageBtn.setImage(UIImage(named: "ic_message")?.withRenderingMode(.alwaysOriginal), for: .normal)
        messageBtn.addTarget(self, action: #selector(didTapMessageButton), for: .touchUpInside)
        messageBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        messageBtn.addSubview(self.messageBadgeView)
        let messageBarBtn = UIBarButtonItem(customView: messageBtn)
        
        switch cardFlow {
        case .dashboard:
            return [messageBarBtn, interviewBarBtn]
        case .shortlisted:
            return []
        }
    }
    
    @objc func didTapMessageButton() {
        let vc = ChatListVC()
        self.messageBadgeView.isHidden = true
        self.shouldShowMessageBadgeView = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapInterviewButton() {
        let sb = UIStoryboard(name: "Card", bundle: nil)
        
        if AppContainer.shared.user.user?.accountType == "organization" {
            
            
            let vc = sb.instantiateViewController(withIdentifier: "EmployerPlannerViewController") as! EmployerPlannerViewController
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            
            let vc = sb.instantiateViewController(withIdentifier: "PlanerViewController") as! PlanerViewController
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
    @IBAction func didTapAcceptButton(_ sender: Any) {
        self.isLastActionDeleted = false
        cardVC?.cardView.swipe(.right)
        //cardVC?.judge(like: .yes)
    }

    @IBAction func didTapRejectButton(_ sender: Any) {
        self.isLastActionDeleted = true
        cardVC?.cardView.swipe(.left)
        //cardVC?.judge(like: .no)
    }

    @IBAction func didTapReloadButton(_ sender: Any) {
        if self.isLastActionDeleted {
//            cardVC?.cardView.resetCurrentCardIndex()
//            cardVC?.cardView.reloadData()
            cardVC?.cardView.revertAction()
            self.isLastActionDeleted = false
        }
    }
   
    @IBAction func didTapStarButton(_ sender: Any) {
        self.isLastActionDeleted = false
        cardVC?.cardView.swipe(.down)
    }

    @IBAction func didTapShortlistButton(_ sender: Any) {
        self.isLastActionDeleted = false
        cardVC?.cardView.swipe(.up)    
    }
    
    @IBAction func didTapJobPickerButton(_ sender: Any) {
        
        guard let data = cardVC?.viewModel.dropDownData else {
            return
        }
        
        if data.count > 0 {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            for i in 0..<data.count {
                actionSheet.addAction(UIAlertAction(title: data[i].title, style: .default, handler: { [weak self](action) in
                    self?.jobSelectorButton.setTitle(data[i].title, for: .normal)
                    self?.selectedJob = data[i]
                    AppContainer.shared.job.save(jobID: data[i].identifier)
                    self?.cardVC?.viewModel.service.getCardData()
                    actionSheet.dismiss(animated: true, completion: nil)
                }))
            }
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    
    //Shortlist
    func shortList(data: CardViewItem) {
        if AppContainer.shared.user.user?.accountType == "organization" {
            self.shortListOrganization(data: data)
        } else {
            self.shortListSeeker(data: data)
        }
    }
    
    //Shortlist organization end
    func shortListOrganization(data: CardViewItem) {
        var param = [String:Any]()
        param["user_id"] = data.id
        param["job_id"] = self.selectedJob?.identifier
        print(param)
        _ = APIClient.callAPI(request: .shortListSeeker(param: param), onSuccess: { (dictionary) in
            print(dictionary)
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    //Shortlist seeker end
    func shortListSeeker(data: CardViewItem) {
        var param = [String:Any]()
        param["job_id"] = data.jobId
        print(param)
        _ = APIClient.callAPI(request: .shortListJob(param: param), onSuccess: { (dictionary) in
            print(dictionary)
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    // like
    func like(data: CardViewItem, isLike: Bool) {
        if AppContainer.shared.user.user?.accountType == "organization" {
            self.likeOrganization(data: data, isLike: isLike)
        } else {
            self.likeSeeker(data: data, isLike: isLike)
        }
    }
    
    //Seeker end
    func likeOrganization(data: CardViewItem, isLike: Bool) {
        
        var params = [String: Any]()
        params["job_id"] = self.selectedJob?.identifier
        params["type"] = "User"
        params["like"] = isLike ? "yes" : "no"
        params["user_id"] = data.id
        print(params)
        _ = APIClient.callAPI(request: .likeEmployeeRequest(param: params), onSuccess: { (dictionary) in
            print(dictionary)
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    //Organization end
    func likeSeeker(data: CardViewItem, isLike: Bool) {
        
        var params = [String: Any]()
        params["job_id"] = data.jobId
        params["type"] = "Job"
        params["like"] = isLike ? "yes" : "no"
        print(params)
        _ = APIClient.callAPI(request: .likeJobRequest(param: params), onSuccess: { (dictionary) in
            print(dictionary)
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    func superLike(data: CardViewItem) {
        
        if AppContainer.shared.user.user?.accountType == "organization" {
            self.superLikeOrganization(data: data)
        } else {
            self.superLikeSeeker(data: data)
        }
    }
    
    //Seeker end
    func superLikeSeeker(data: CardViewItem) {
        let jobId = data.jobId
        
        var params = [String: Any]()
        params["job_id"] = jobId
        params["type"] = "Job"
        params["like"] = "yes"
        
        _ = APIClient.callAPI(request: APIClient.superlikeJobSeekerRequest(param: params), onSuccess: { (dictionary) in
            
            print(dictionary)
            let superlikeResponse = Mapper<OrganizationSuperLikeResponse>().map(JSON: dictionary)
            print(superlikeResponse?.toJSON())
            
            //let chatVC = ChatMessagesVC()
            let sb = UIStoryboard(name: "Chat", bundle: nil)
            let chatVC = sb.instantiateViewController(withIdentifier: "ChatMessagesVC") as! ChatMessagesVC
            
            let jobSeekerId = superlikeResponse!.jobseekerId as? Int
            chatVC.jobSeekerId = jobSeekerId
            chatVC.seekerName = data.title
            chatVC.conversationId = superlikeResponse?.conversationId
            chatVC.jobTitle = self.selectedJob?.title
            chatVC.jobId = self.selectedJob?.identifier
            chatVC.seekerPicture = data.imageName
            chatVC.title = data.title
            
            self.navigationController?.pushViewController(chatVC, animated: true)
            
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    //Organization end
    func superLikeOrganization(data: CardViewItem) {
        guard let jobId = self.selectedJob?.identifier else {
            return
        }
        var params = [String: Any]()
        params["user_id"] = data.id
        params["job_id"] = jobId
        params["type"] = "User"
        params["like"] = "yes"
        
        print(params)
        
        _ = APIClient.callAPI(request: APIClient.superLikeEmployerRequest(param: params), onSuccess: { (dictionary) in
            
            print(dictionary)
            let superlikeResponse = Mapper<OrganizationSuperLikeResponse>().map(JSON: dictionary)
            print(superlikeResponse?.toJSON())
            
            //let chatVC = ChatMessagesVC()
            
            let sb = UIStoryboard(name: "Chat", bundle: nil)
            let chatVC = sb.instantiateViewController(withIdentifier: "ChatMessagesVC") as! ChatMessagesVC
            
            let jobSeekerId = superlikeResponse!.jobseekerId as? Int
            chatVC.jobSeekerId = jobSeekerId
            chatVC.seekerName = data.title
            chatVC.conversationId = superlikeResponse?.conversationId
            chatVC.jobTitle = self.selectedJob?.title
            chatVC.jobId = self.selectedJob?.identifier
            chatVC.seekerPicture = data.imageName
            chatVC.title = data.title
            
            self.navigationController?.pushViewController(chatVC, animated: true)
            
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
}

extension CardViewController: CardContainerViewControllerDelegate {
    func didFetchedDropDownData() {

        guard let data = cardVC?.viewModel.dropDownData else { return }

        if data.count > 0 {
            self.jobSelectorButton.setTitle(data[0].title, for: .normal)
            AppContainer.shared.job.save(jobID: data[0].identifier)
            self.selectedJob = data[0]
            cardVC?.viewModel.service.getCardData()
        } else {
            self.jobSelectorButton.setTitle("No Jobs Available", for: .normal)
        }
    }
}

extension CardViewController: Initializable {
    static var storyboardName: String {
        return UIStoryboard.Name.cards.rawValue
    }
}
