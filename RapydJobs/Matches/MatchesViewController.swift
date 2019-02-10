//
//  MatchesViewController.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 01/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import JGProgressHUD


class MatchesViewController: BaseViewController {
    
    private let network: Network! = Network.shared

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        return hud
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    var jobseekerJobMatches: JobseekerJobMatches!
    var jobseekerMatches = [JobMatches]()
    var employerMatches: EmployerJobseekerMatches!
    var jobMatches = [JobMatch]()
    var dropDownData = [JobsDropDownItem]();
    var data = [EmployerJobsDropdownResponse]();
    var selectedJob: JobsDropDownItem!
    
    @IBOutlet weak var emptyPlaceholderView: EmptyPlaceholderView! {
        didSet {
            self.emptyPlaceholderView.message.text = "You haven't matches yet"
        }
    }
    
    var toast: JYToast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toast = JYToast()

        self.title = "Matches"
        
        // Navigation items
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        self.tableView.register(UINib(nibName: "MatchesTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if let accountType = AppContainer.shared.user.user?.accountType {
            if accountType == "organization" {
                let filterBtn: UIButton = UIButton(type: UIButtonType.custom)
                filterBtn.setImage(UIImage(named: "ic_filter")?.withRenderingMode(.alwaysOriginal), for: .normal)
                filterBtn.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
                filterBtn.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
                let filterBarBtn = UIBarButtonItem(customView: filterBtn)
                self.navigationItem.rightBarButtonItem = filterBarBtn
                
                self.getEmployerDropdownJobs()
            } else {
                self.getData()
            }
        }
    }
    
    func getJobSeekerMatchList() {
        _ = APIClient.callAPI(request: .getJobSeekerMatchList, onSuccess: { (dictionary) in
            print(dictionary)
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    private func getData(jobId: String = "") {
        if AppContainer.shared.user.user?.accountType == "jobseeker" {
            hud.show(in: view)
            MatchesAPISevice.shared.getJobseekerMatches(limit: "20") { (jobMatches, error) in
                self.hud.dismiss(animated: true)
                if let err = error {
                    print("Error : ", err)
                } else {
                    self.jobseekerMatches = jobMatches!.jobMatches
                    self.jobseekerJobMatches = jobMatches!
                    self.reloadTable()
                    self.hideProgress()
                    if self.jobseekerMatches.count == 0 {
                        self.emptyPlaceholderView.isHidden = false
                    } else {
                        self.emptyPlaceholderView.isHidden = true
                    }
                }
            }
        } else {
            hud.show(in: view)
            MatchesAPISevice.shared.getEmployerMatches(jobId: jobId, limit: "20") { (matches, error) in
                self.hud.dismiss(animated: true)
                if let err = error {
                    print("Error : ", err)
                } else {
                    self.employerMatches = matches!
                    self.jobMatches = matches!.jobMatches
                    self.reloadTable()
                    self.hideProgress()
                    if self.jobMatches.count == 0 {
                        self.emptyPlaceholderView.isHidden = false
                    } else {
                        self.emptyPlaceholderView.isHidden = true
                    }
                }
            }
        }
    }
    
    func getEmployerDropdownJobs() {
        let request = EmployerJobsDropdownRequest()
        hud.show(in: view)
        network.request(request) { result in
            self.hud.dismiss(animated: true)
            switch result {
            case let .success(dto):
                self.data = dto
                
                self.dropDownData = dto.map(JobsDropDownItem.init)
                //let id = "\(String(describing: self.dropDownData.first?.identifier))"
                guard let jobsDropDownItem = self.dropDownData.first else {
                    return
                }
                self.selectedJob = jobsDropDownItem
                let strngId = "\(jobsDropDownItem.identifier)"
                print(strngId)
                self.getData(jobId: strngId)
                
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func didTapFilterButton() {
        if self.dropDownData.count > 0 {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            for i in 0..<data.count {
                actionSheet.addAction(UIAlertAction(title: data[i].title, style: .default, handler: { (action) in
                    //self?.jobSelectorButton.setTitle(data[i].title, for: .normal)
                    //AppContainer.shared.job.save(jobID: self.dropDownData[i].identifier)
                    //self?.cardVC?.viewModel.service.getCardData()
                    self.selectedJob = self.dropDownData[i]
                    self.getData(jobId: "\(self.dropDownData[i].identifier)")
                    actionSheet.dismiss(animated: true, completion: nil)
                }))
            }
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
}

extension MatchesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AppContainer.shared.user.user?.accountType == "jobseeker" {
            return jobseekerMatches.count
        } else {
            return jobMatches.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MatchesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MatchesTableViewCell else {
            return UITableViewCell()
        }
        cell.shouldDrawFullShadow = true
        cell.delegate = self

        if AppContainer.shared.user.user?.accountType == "jobseeker" {
            if jobseekerMatches.count > 0 {
                let jobMatches = jobseekerMatches[indexPath.row]
                cell.populateWithJobseekerMatchModel(jobMatches)
            }
        } else {
            if jobMatches.count > 0 {
                let jobMatch = jobMatches[indexPath.row]
                cell.populateWithJobMatchModel(jobMatch)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if AppContainer.shared.user.user?.accountType ?? "" == "jobseeker" {
            let sb = UIStoryboard(name: "JobDetails", bundle: nil)
            let vc = sb.instantiateInitialViewController() as! JobDetailsViewController
            let item = jobseekerMatches[indexPath.row]
            print(item)
            vc.jobId = "\(item.id)"
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let profileDetailsVC = JobSeekerProfileViewController.getInstance()
            let item = jobMatches[indexPath.row]
            profileDetailsVC.jobseekerId = item.pivot.jobseekerId
            self.navigationController?.pushViewController(profileDetailsVC, animated: true)
        }
        
    }

    func showProgress() {
        self.showProgressView()
    }
    
    func hideProgress() {
        self.hideProgressView()
    }
    
    func reloadTable() {
        self.tableView.reloadData()
    }
}

extension MatchesViewController: MatchesTableViewCellDelegate {
    func didTapMessageButtonOnCell(_ cell: MatchesTableViewCell) {
        
        let indexPath = self.tableView.indexPath(for: cell)
        
        if AppContainer.shared.user.user?.accountType == "jobseeker" {
            let item = jobseekerMatches[indexPath!.row]
            
            let sb = UIStoryboard(name: "Chat", bundle: nil)
            let chatVC = sb.instantiateViewController(withIdentifier: "ChatMessagesVC") as! ChatMessagesVC
            
            
            chatVC.jobSeekerId = item.userId
            chatVC.conversationId = Int(item.conversationId)
            chatVC.jobId = item.jobOwner.id
            chatVC.title = item.title
            chatVC.jobTitle = item.title
            chatVC.seekerPicture = item.jobOwner.profileImage
            print(item)
            self.navigationController?.pushViewController(chatVC, animated: true)
        } else {
            let jobMatch = jobMatches[indexPath!.row]
            
            let sb = UIStoryboard(name: "Chat", bundle: nil)
            let chatVC = sb.instantiateViewController(withIdentifier: "ChatMessagesVC") as! ChatMessagesVC
            
            
            chatVC.jobSeekerId = jobMatch.pivot.jobseekerId
            chatVC.conversationId = Int(jobMatch.pivot.conversationId)
            chatVC.jobId = self.selectedJob.identifier
            chatVC.jobTitle = self.selectedJob.title
            chatVC.seekerName = jobMatch.username
            chatVC.seekerPicture = jobMatch.profileImage
            chatVC.title = jobMatch.username
            self.navigationController?.pushViewController(chatVC, animated: true)
            
        }
        
    }
}

extension MatchesViewController: Initializable {
    static var storyboardName: String {
        return UIStoryboard.Name.matches.rawValue
    }
}
