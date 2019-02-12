//
//  JobSeekerProfileViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/25/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import Segmentio
import Cosmos
import ObjectMapper
import SwiftWebVC

class JobSeekerProfileViewController: UIViewController {
    let sectionArray = ["Basic Information", "Experience Information", "Education", "Language"]
    var reviews: [SeekerReview]?
    
    var currentPage = 1
    var lastPage = 0
    var isLoadMore: Bool = false
    var isLoading: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var acceptButton: ProfileDetailsButton!
    @IBOutlet weak var rejectButton: ProfileDetailsButton!
    @IBOutlet weak var shortlistButton: ProfileDetailsButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var segmentControl: SegmentControl!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyPlaceholderView: EmptyPlaceholderView! {
        didSet {
            self.emptyPlaceholderView.message.text = "No review found"
        }
    }
    
    var viewModel: ProfileDetailsViewModel = ProfileDetailsViewModel()
    
    var toast: JYToast!
    
    var jobseekerId: Int?
    var jobSeeker: UserResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.toast = JYToast()
        
        if AppContainer.shared.user.user?.accountType ?? ""  == "organization" {
            self.shortlistButton.isHidden = true
            self.getJobseeker()
            
        }
        
        
        // Setting table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProfileDetailsTableHeaderCell", bundle: Bundle.main), forCellReuseIdentifier: "headerCell")
        tableView.register(UINib(nibName: "ProfileDetailsTableInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "infoCell")
        tableView.register(UINib(nibName: "ProfileDetailsTableReviewCell", bundle: Bundle.main), forCellReuseIdentifier: "reviewCell")
        tableView.register(UINib(nibName: "ReviewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ReviewTableViewCellID")
        tableView.register(UINib(nibName: "ProfileInfoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileInfoTableViewCellID")
        tableView.register(UINib(nibName: "DownloadResumeTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DownloadResumeTableViewCellID")
        
        
        // Setting profile image view
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width/2
        profileImageView.layer.masksToBounds = true
        
        rejectButton.isHidden = true
        acceptButton.isHidden = true
        shortlistButton.setTitle("Edit Profile", for: .normal)
        
        // Setting segment
        self.segmentControl.content = viewModel.segmentData
        self.segmentControl.valueDidChange = { segmentio, segmentIndex in
            if segmentIndex == 0 {
                self.emptyPlaceholderView.isHidden = true
                self.currentPage = 1
                self.lastPage = 0
                self.isLoadMore = false
                self.isLoading = false
                
                self.tableView.reloadData()
            } else {
                self.reviews?.removeAll()
                self.tableView.reloadData()
                self.getReview()
            }
            
        }
    }
    
    func getJobseeker() {
        guard let id = self.jobseekerId else {
            print("Weak Internet Connection")
            return
        }
        _ = APIClient.callAPI(request: .getJobseeker(id: id), onSuccess: { (dictionary) in
            
            
            guard let seekerObj: UserResponseModel = Mapper<UserResponseModel>().map(JSON: dictionary) else {
                return
            }
            self.jobSeeker = seekerObj
            
            self.title = self.jobSeeker?.userName ?? ""
            self.nameLabel.text = self.jobSeeker?.userName ?? ""
            self.coverImageView.setImageWithName(self.jobSeeker?.profileImage ?? "", isCompleteUrl: true)
            self.profileImageView.setImageWithName(self.jobSeeker?.profileImage ?? "", isCompleteUrl: true)
            self.subtitleLabel.text = self.jobSeeker?.jobSeeker?.description ?? ""
            print(self.jobSeeker?.totalRating ?? 0.0)
            self.ratingView.rating = self.jobSeeker?.totalRating ?? 0.0
            self.tableView.reloadData()
            
        }) { (errorDictionary, _) in
            print(errorDictionary)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    @IBAction func editProfile(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "JobseekerSignup", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditProfileViewControllerID") as! EditProfileViewController
        
        let navController = UINavigationController(rootViewController: vc)
        
        
        self.present(navController, animated: true, completion: nil)
        
    }
    
    func getReview() {
        guard let id = self.jobseekerId else {
            return
        }
        self.isLoading = true
        let numberOfItems = 10
        _ = APIClient.callAPI(request: .review(id: id,numberOfItems: numberOfItems, page: self.currentPage), onSuccess: { (dictionary) in
            self.isLoading = false
            print(dictionary)
            
            let lastPage = dictionary["last_page"] as? Int ?? 0
            
            self.lastPage = lastPage + 1
            
            guard let data = dictionary["data"] as? [[String:Any]] else {
                return
            }
            
            let review = Mapper<SeekerReview>().mapArray(JSONArray: data)
            if review.count > 0 {
                self.currentPage += 1
            }
            
            if self.isLoadMore {
                for item in review {
                    self.reviews?.append(item)
                }
            } else {
                self.reviews = review
            }
            
            //self.reviews = Mapper<SeekerReview>().mapArray(JSONArray: data)
            self.tableView.reloadData()
            if self.reviews?.count == 0 {
                self.emptyPlaceholderView.isHidden = false
            } else {
                self.emptyPlaceholderView.isHidden = true
            }
        }) { (errorDictionary, _) in
            self.isLoading = false
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    func getOrganizationPrifle() { // not calling
        _ = APIClient.callAPI(request: .myProfileOrganization, onSuccess: { (dictionary) in
            let user: UserResponseModel = Mapper<UserResponseModel>().map(JSON: dictionary)!
            self.coverImageView.setImageWithName(user.profileImage!)
            self.profileImageView.setImageWithName(user.profileImage!)
            
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
        }
    }
    
    private func getData() { // Not using
        JobseekerProfileAPIService.shared.getJobseekerPersonalProfile { (jobseeker, error) in
            if let err = error {
                print("🔥 Error : ", err)
            } else {
                if let jobseeker = jobseeker {
                    self.ratingView.rating = Double(jobseeker.totalRating)
                    self.nameLabel.text = jobseeker.username.capitalized
                    if jobseeker.experience.count > 0 {
                        self.subtitleLabel.text = jobseeker.experience[0].title.capitalized + " @ " + jobseeker.experience[0].companyName.capitalized
                    }
                    self.coverImageView.setImageWithName(jobseeker.profileImage)
                    self.profileImageView.setImageWithName(jobseeker.profileImage)
                }
            }
        }
    }
    
    func viewCV() {
        
        guard let jobSeeker = self.jobSeeker,
            let cv = jobSeeker.jobSeeker?.cv else {
                AlertService.shared.alert(in: self, "No CV Found")
                return
        }
        
        let baseurl = "http://ec2-18-191-9-134.us-east-2.compute.amazonaws.com/RapydJobs/storage/cv/\(cv)"
        
        let webVC = SwiftModalWebVC(urlString: baseurl) //"http://google.com"
        self.present(webVC, animated: true, completion: nil)
        
    }
}

extension JobSeekerProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension JobSeekerProfileViewController: UITableViewDataSource {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            self.isLoadMore = true
            if self.currentPage < lastPage, !self.isLoading {
                self.getReview()
            }
            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.segmentControl.selectedSegmentioIndex == 0 {
            return self.sectionArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentControl.selectedSegmentioIndex == 0 {
            
            guard let user = self.jobSeeker else {
                return 0
            }
            
            if section == 0 {
                return 4
            } else if section == 1 {
                return (user.experience?.count ?? 0) + 1
            } else if section == 2 {
                return (user.education?.count ?? 0) + 1
            } else {
                return (user.language?.count ?? 0) + 1
            }
            
        } else {
            return self.reviews?.count ?? 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:ShdaowBaseTableViewCell
        
        if segmentControl.selectedSegmentioIndex == 0 {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! ProfileDetailsTableHeaderCell
                    headerCell.titleLabel.text = self.sectionArray[indexPath.section] // viewModel.titleForSection(indexPath.section)
                    cell = headerCell
                    
                    cell.isFirstCell = indexPath.row == 0
                    cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
                    
                    return cell
                case 1:
                    let infoCell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoTableViewCellID", for: indexPath) as! ProfileInfoTableViewCell
                    
                    infoCell.titleLabel.text = self.jobSeeker?.address?.address ?? "" // basicInfo.text
                    infoCell.iconView?.image = UIImage(named: "ic_location")
                    cell = infoCell
                    
                    cell.isFirstCell = indexPath.row == 0
                    cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
                    
                    return cell
                case 2:
                    let infoCell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoTableViewCellID", for: indexPath) as! ProfileInfoTableViewCell
                    
                    infoCell.titleLabel.isHidden = false
                    infoCell.titleLabel.text = "-" // "£0 Per Hour"
                    infoCell.iconView?.image = UIImage(named: "ic_wallet")
                    cell = infoCell
                    
                    cell.isFirstCell = indexPath.row == 0
                    cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
                    
                    return cell
                case 3:
                    let infoCell = tableView.dequeueReusableCell(withIdentifier: "DownloadResumeTableViewCellID", for: indexPath) as! DownloadResumeTableViewCell
                    
                    infoCell.downloadCompletion = {
                        self.viewCV()
                    }
                    
                    infoCell.iconView?.image = UIImage(named: "ic_download")
                    cell = infoCell
                    
                    cell.isFirstCell = indexPath.row == 0
                    cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
                    
                    return cell
                default:
                    return UITableViewCell()
                    
                }
                
            case 1: //Experience
                if indexPath.row == 0 {
                    let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! ProfileDetailsTableHeaderCell
                    headerCell.titleLabel.text = self.sectionArray[indexPath.section]
                    cell = headerCell
                    
                    cell.isFirstCell = indexPath.row == 0
                    cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
                    
                    return cell
                    
                } else {
                    guard let experience = self.jobSeeker?.experience?[indexPath.row - 1] else {
                        return UITableViewCell()
                    }
                    
                    let infoCell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! ProfileDetailsTableInfoCell
                    
                    infoCell.titleLabel.isHidden = false
                    infoCell.downloadBtn.isHidden = true
                    
                    infoCell.toggleButton.isHidden = false
                    infoCell.delegate = self
                    infoCell.titleLabel.textColor = infoCell.experienceLabelColor
                    infoCell.titleLabel.text = experience.title ?? "" //jobTitle
                    infoCell.organisationLabel.text = experience.companyName ?? "" //organisationName
                    infoCell.durationLabel.text = experience.duration
                    infoCell.iconView?.image = UIImage(named: "ic_jobs")
                    
                    cell = infoCell
                    
                    cell.isFirstCell = indexPath.row == 0
                    cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
                    
                    return cell
                    
                }
            case 2: //Education
                if indexPath.row == 0 {
                    let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! ProfileDetailsTableHeaderCell
                    headerCell.titleLabel.text = self.sectionArray[indexPath.section]
                    cell = headerCell
                    
                    cell.isFirstCell = indexPath.row == 0
                    cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
                    
                    return cell
                } else {
                    guard let education = self.jobSeeker?.education?[indexPath.row - 1] else {
                        return UITableViewCell()
                    }
                    
                    let infoCell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! ProfileDetailsTableInfoCell
                    
                    infoCell.titleLabel.isHidden = false
                    infoCell.downloadBtn.isHidden = true
                    
                    infoCell.toggleButton.isHidden = false
                    infoCell.delegate = self
                    infoCell.titleLabel.textColor = infoCell.experienceLabelColor
                    infoCell.titleLabel.text = education.title ?? "" //jobTitle
                    infoCell.organisationLabel.text = education.instituteName ?? "" //organisationName
                    infoCell.durationLabel.text = education.duration
                    infoCell.iconView?.image = UIImage(named: "ic_jobs")
                    
                    infoCell.gradeLabel.isHidden = false
                    infoCell.gradeLabel.text = "Grade : " + String(education.grade ?? "-")
                    
                    cell = infoCell
                    
                    cell.isFirstCell = indexPath.row == 0
                    cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
                    
                    return cell
                }
            case 3: //Language
                if indexPath.row == 0 {
                    let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! ProfileDetailsTableHeaderCell
                    headerCell.titleLabel.text = self.sectionArray[indexPath.section]
                    cell = headerCell
                    return cell
                } else {
                    
                    guard let language = self.jobSeeker?.language?[indexPath.row - 1] else {
                        return UITableViewCell()
                    }
                    
                    let infoCell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! ProfileDetailsTableInfoCell
                    
                    infoCell.titleLabel.isHidden = false
                    infoCell.downloadBtn.isHidden = true
                    
                    infoCell.toggleButton.isHidden = false
                    infoCell.delegate = self
                    infoCell.titleLabel.textColor = infoCell.experienceLabelColor
                    infoCell.titleLabel.text = language.language ?? "" //jobTitle
                    infoCell.organisationLabel.text = language.level ?? "" // "-" // language.instituteName ?? "" //organisationName
                    infoCell.durationLabel.text = "" // language.duration
                    infoCell.iconView?.image = UIImage(named: "ic_jobs")
                    
                    cell = infoCell
                    
                    cell.isFirstCell = indexPath.row == 0
                    cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
                    
                    return cell
                    
                }
            default:
                return UITableViewCell()
                
            }
        } else { // segment index 1
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCellID", for: indexPath) as! ReviewTableViewCell
            guard let review = self.reviews?[indexPath.row] else {
                return UITableViewCell()
            }
            cell.orgImage.setImageWithName(review.from?.profileImage ?? "")
            cell.orgName.text = review.from?.username ?? ""
            cell.review.text = review.review ?? ""
            cell.ratingView.rating = review.star ?? 0.0
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return segmentControl.selectedSegmentioIndex == 0 ? 10 : 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return segmentControl.selectedSegmentioIndex == 0 ? 10 : 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.segmentControl.selectedSegmentioIndex == 0 {
            return UITableViewAutomaticDimension
        }
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension JobSeekerProfileViewController: ProfileDetailsTableInfoCellDelegate {
    func infoCellLayoutChanged(_ infoCell: ProfileDetailsTableInfoCell) {
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.setNeedsDisplay()
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
}

extension JobSeekerProfileViewController: Initializable {
    static var storyboardName: String {
        return UIStoryboard.Name.profileDetails.rawValue
    }
}

