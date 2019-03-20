//
//  JobDetailsAndCandidateViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 3/20/19.
//  Copyright © 2019 chymps. All rights reserved.
//

import UIKit
import Segmentio
import ObjectMapper

class JobDetailsAndCandidateViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.register(
                UINib(nibName: "BasicInformationCell", bundle: .main),
                forCellReuseIdentifier: "information-cell")
            tableView.register(
                UINib(nibName: "DescriptionCell", bundle: .main),
                forCellReuseIdentifier: "description-cell")
        }
    }
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var segmentControl: SegmentControl! {
        didSet {
            segmentControl.valueDidChange = { [unowned self] _, _ in
                self.tableView.reloadData()
            }
        }
    }
    
    var sectionArray = ["Basic Information", "Job Description",]
    var organizatioJob: OrganizationJob?
    var jobCandidates: [JobCandidate] = [JobCandidate]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let job = self.organizatioJob else {
            return
        }
        print(job.toJSON())
        
        
        self.titleLabel.text = job.title ?? "Not provided"
        self.subtitle.text = job.status ?? "Not provided"
        
        // Setting table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProfileDetailsTableHeaderCell", bundle: Bundle.main), forCellReuseIdentifier: "headerCell")
        tableView.register(UINib(nibName: "ProfileDetailsTableInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "infoCell")
        tableView.register(UINib(nibName: "ProfileDetailsTableReviewCell", bundle: Bundle.main), forCellReuseIdentifier: "reviewCell")
        tableView.register(UINib(nibName: "ReviewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ReviewTableViewCellID")
        tableView.register(UINib(nibName: "ProfileInfoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileInfoTableViewCellID")
        tableView.register(UINib(nibName: "DownloadResumeTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DownloadResumeTableViewCellID")
        tableView.register(UINib(nibName: "CandidateTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CandidateTableViewCellID")
        
        
        self.segmentControl.content = [
            SegmentioItem(title: "Details",image: UIImage(named: "")),
            SegmentioItem(title: "Candidates",image: UIImage(named: ""))
        ]
        
        self.segmentControl.valueDidChange = { segmentio, segmentIndex in
            if segmentIndex == 0 {
                self.jobCandidates.removeAll()
                self.sectionArray = ["Basic Information", "Job Description",]
                self.tableView.reloadData()
            } else {
                self.sectionArray.removeAll()
                self.tableView.reloadData()
                self.getCandidates()
                
            }
            
        }
        
    }
    
    func getCandidates() {
        guard let jobId = self.organizatioJob?.id else {
            return
        }
        _ = APIClient.callAPI(request: APIClient.getCandidates(jobId: "\(jobId)"), onSuccess: { (dictionary) in
            if let data = dictionary["data"] as? [[String:Any]] {
                let candidates: [JobCandidate] = Mapper<JobCandidate>().mapArray(JSONArray: data)
                self.jobCandidates = candidates
                self.tableView.reloadData()
            }
        }) { (errorDictionary, _) in
            print(errorDictionary)
        }
    }

}

extension JobDetailsAndCandidateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return segmentControl.selectedSegmentioIndex == 0 ? 10 : 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if segmentControl.selectedSegmentioIndex == 1 {
            return 90
        }
        return tableView.estimatedRowHeight
    }
}

extension JobDetailsAndCandidateViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentControl.selectedSegmentioIndex == 0 {
            return self.sectionArray.count
        }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControl.selectedSegmentioIndex == 0 {
            if section == 0 {
                return 4
            }
            return 2
        }
        return self.jobCandidates.count
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
                    
                    var relatedFieldsSring: String = ""
                    if let relatedFields = self.organizatioJob?.jobsRelatedField {
                        for i in 0..<relatedFields.count {
                            if i == 0 {
                                relatedFieldsSring = "Industries: \(relatedFields[i]["related_field"] as? String ?? "")"
                            } else {
                                relatedFieldsSring = "\(relatedFieldsSring), \(relatedFields[i]["related_field"] as? String ?? "")"
                            }
                        }
                    } else {
                        relatedFieldsSring = "Not Provided"
                    }
                    
                    infoCell.titleLabel.text = relatedFieldsSring
                    infoCell.iconView?.image = UIImage(named: "ic_location")
                    cell = infoCell
                    
                    cell.isFirstCell = indexPath.row == 0
                    cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
                    
                    return cell
                case 2:
                    let infoCell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoTableViewCellID", for: indexPath) as! ProfileInfoTableViewCell
                    
                    let maxSalary: String = "\(self.organizatioJob?.maxSalary ?? 0)"
                    let minSalary: String = "\(self.organizatioJob?.minSalary ?? 0)"
                    
                    infoCell.titleLabel.text = "From £\(String(describing: minSalary)) to £\(String(describing: maxSalary)) Per Hour Rate"
                    infoCell.iconView?.image = UIImage(named: "ic_wallet")
                    
                    cell = infoCell
                    
                    cell.isFirstCell = indexPath.row == 0
                    cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
                    
                    return cell
                case 3:
                    let infoCell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoTableViewCellID", for: indexPath) as! ProfileInfoTableViewCell
                    
                    infoCell.iconView?.image = UIImage(named: "ic_download")
                    
                    var datesSring: String = ""
                    if let dates = self.organizatioJob?.dates {
                        
                        for i in 0..<dates.count {
                            if i == 0 {
                                datesSring = dates[i].day ?? ""
                            } else {
                                datesSring = "\(datesSring), \(dates[i].day ?? "")"
                            }
                        }
                    
                    } else {
                        datesSring = "Not provided"
                    }
                    infoCell.titleLabel.text = datesSring
                    cell = infoCell
                    
                    cell.isFirstCell = indexPath.row == 0
                    cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
                    
                    return cell
                default:
                    return UITableViewCell()
                    
                }
            default:
                switch indexPath.row {
                case 0:
                    let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! ProfileDetailsTableHeaderCell
                    headerCell.titleLabel.text = self.sectionArray[indexPath.section] // viewModel.titleForSection(indexPath.section)
                    cell = headerCell
                    
                    cell.isFirstCell = indexPath.row == 0
                    cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
                    
                    return cell
                case 1:
                    let descCell = tableView.dequeueReusableCell(withIdentifier: "description-cell") as! DescriptionTableViewCell
                    
                    descCell.descriptionTextView.text = self.organizatioJob?.description ?? "Not provided"
                    cell = descCell
                    cell.isFirstCell = indexPath.row == 0
                    cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
                    return cell
                    
                default:
                    let cell = UITableViewCell()
                    return cell
                }
            }
            
        } else { // Segment Index 1
            let cell = tableView.dequeueReusableCell(withIdentifier: "CandidateTableViewCellID", for: indexPath) as! CandidateTableViewCell
            let candidate = self.jobCandidates[indexPath.row]
            cell.candidateName.text = candidate.fullName ?? ""
            cell.isFirstCell = true
            cell.isLastCell = true
            
            cell.callForAnInterView = {
                print("callForAnInterView")
            }
            
            cell.reject = {
                print("reject")
            }
            
            cell.candidateImage.setImageWithName(candidate.profileImage ?? "", isCompleteUrl: true)
            print(candidate.toJSON())
            return cell
        }
        
//        return UITableViewCell()
    }
    
}
