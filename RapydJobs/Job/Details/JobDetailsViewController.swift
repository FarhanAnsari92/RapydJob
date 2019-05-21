//
//  JobDetailsViewController.swift
//  RapydJobs
//
//  Created by Maroof Khan on 08/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import ObjectMapper

class JobDetailsViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(
            UINib(nibName: "ProfileInfoTableViewCell", bundle: .main),
            forCellReuseIdentifier: "ProfileInfoTableViewCellID")
            tableView.register(
                UINib(nibName: "DescriptionCell", bundle: .main),
                forCellReuseIdentifier: "description-cell")
            tableView.register(
                UINib(nibName: "ProfileDetailsTableHeaderCell", bundle: .main),
                forCellReuseIdentifier: "headerCell") //ProfileDetailsTableHeaderCellID
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
    @IBOutlet weak var deleteButton: UIButton! {
        didSet {
            deleteButton.layer.cornerRadius = deleteButton.bounds.midY
            deleteButton.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
    @IBOutlet weak var ctaButton: UIButton! {
        didSet {
            ctaButton.layer.cornerRadius = ctaButton.bounds.midY
            ctaButton.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
    
    var viewModel: JobDetailsViewModel!
    var item: CardViewItem?
    var rawItem: [String:Any]?
    var jobMatch: JobMatches?
    
    var jobModel: JobDetailModel?
    var jobId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayImageView.layer.cornerRadius = 50.0
        
        let accountType = AppContainer.shared.user.user?.accountType ?? ""
        
        if accountType == "jobseeker" {
  
            if let _ = item {
                coverImageView.setImageWithName(item?.imageName ?? "")
                displayImageView.setImageWithName(item?.imageName ?? "")
                titleLabel.text = item?.title ?? ""
                subtitle.text = item?.subtitle ?? ""
            } else if let rwItm = rawItem {
                coverImageView.setImageWithName(rwItm["profile_image"] as? String ?? "")
                displayImageView.setImageWithName(rwItm["profile_image"] as? String ?? "")
                titleLabel.text = rwItm["title"] as? String ?? ""
                subtitle.text = rwItm["organization_name"] as? String ?? ""
            } else if let jobItm = self.jobMatch {
                print(jobItm)
                coverImageView.setImageWithName(jobItm.jobOwner.profileImage)
                displayImageView.setImageWithName(jobItm.jobOwner.profileImage)
                titleLabel.text = jobItm.title
                subtitle.text = jobItm.jobOwner.organization.organizationName
                
                
                
            }
            
            self.getJobDetail()
            
            self.ctaButton.isHidden = true
            self.deleteButton.isHidden = true
        
        }
        
    }
    
    func getJobDetail() {
        
        guard let id = self.jobId else {
            return
        }
        
        _ = APIClient.callAPI(request: .getJobDetail(jobId: id), onSuccess: { (dictionary) in
            
            let jobModel = Mapper<JobDetailModel>().map(JSON: dictionary)
            self.jobModel = jobModel
            
            self.coverImageView.setImageWithName(jobModel?.profileImage ?? "")
            self.displayImageView.setImageWithName(jobModel?.profileImage ?? "")
            self.titleLabel.text = jobModel?.title ?? ""
            self.subtitle.text = jobModel?.organizationName ?? ""
            
            
            self.tableView.reloadData()
            
        }) { (errorDictionary, _) in
            print(errorDictionary)
        }
        
    }
    
}

extension JobDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoTableViewCellID", for: indexPath) as! ProfileInfoTableViewCell
            cell.iconView.image = UIImage(named: "ic_location")
            cell.titleLabel.text = self.jobModel?.address?.address ?? ""
            
            if let _ = self.item {
                cell.titleLabel.text = item?.location ?? ""
            } else if let rwItm = self.rawItem {
                let addressDetail = rwItm["address"] as? [String: Any] ?? [String: Any]()
                let address = addressDetail["address"] as? String ?? "Not Provided"
                cell.titleLabel.text = address
            } else if let jobItm = self.jobMatch {
                cell.titleLabel.text = self.jobMatch?.jobOwner.organization.website ?? ""
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoTableViewCellID", for: indexPath) as! ProfileInfoTableViewCell
            
            cell.iconView.image = UIImage(named: "ic_wallet")
            let minSalary = self.jobModel?.minSalary ?? 0
            let maxSalary = self.jobModel?.maxSalary ?? 0
            cell.titleLabel.text = "£\(minSalary) - £\(maxSalary) Per Hour Rate"
            
            if let _ = self.item {
                let minSalary = self.jobModel?.minSalary ?? 0
                let maxSalary = self.jobModel?.maxSalary ?? 0
                cell.titleLabel.text = "£\(minSalary) - £\(maxSalary) Per Hour Rate"
            } else if let rwItm = self.rawItem {
                let minSalary = rwItm["min_salary"] as? Int ?? 0
                let maxSalary = rwItm["max_salary"] as? Int ?? 0
                cell.titleLabel.text = "£\(minSalary) - £\(maxSalary) Per Hour Rate"
            } else if let jobItm = self.jobMatch {
                let minSalary = jobItm.minSalary
                let maxSalary = jobItm.maxSalary
                cell.titleLabel.text = "£\(minSalary) - £\(maxSalary) Per Hour Rate"
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoTableViewCellID", for: indexPath) as! ProfileInfoTableViewCell
            
            cell.iconView.image = UIImage(named: "ic_calendar")
            if let wks = self.jobModel?.dates, wks.count > 0 {
                var str = ""
                for item in wks {
                    str += "\(item.day ?? ""), "
                }
                str.remove(at: str.index(before: str.endIndex))
                cell.titleLabel.text = str
            }
            
            if let _ = self.item {
                if let wks = self.jobModel?.dates, wks.count > 0 {
                    var str = ""
                    for item in wks {
                        str += "\(item.day ?? ""), "
                    }
                    str.remove(at: str.index(before: str.endIndex))
                    cell.titleLabel.text = str
                }
            } else if let rwItm = self.rawItem {
                let dates = rwItm["dates"] as? [[String: Any]]
                if let wks = dates, wks.count > 0 {
                    var str = ""
                    for item in wks {
                        str += "\(item["day"] as? String ?? ""), "
                    }
                    str.remove(at: str.index(before: str.endIndex))
                    
                    cell.titleLabel.text = str
                }
            } else if let jobItm = self.jobMatch {
                if let wks = self.jobMatch?.dates, wks.count > 0 {
                    var str = ""
                    for item in wks {
                        str += "\(item.day), "
                    }
                    str.remove(at: str.index(before: str.endIndex))
                    cell.titleLabel.text = str
                }
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "description-cell") as! DescriptionTableViewCell
            
            cell.descriptionTextView.text = self.jobModel?.description ?? ""
            
            if let _ = self.item {
                cell.descriptionTextView.text = item?.description ?? ""
            } else if let rwItm = self.rawItem {
                cell.descriptionTextView.text = rwItm["description"] as? String ?? ""
            } else if let jobItm = self.jobMatch {
                cell.descriptionTextView.text = jobItm.descriptionField
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let sb = UIStoryboard(name: "Timesheet", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ShowTimeSheetViewControllerID") as! ShowTimeSheetViewController
            if let dateArr = self.jobModel?.dates, dateArr.count > 0 {
                var dates = [AvailabilityDTO]()                
                for date in dateArr {
                    let dateDTO = AvailabilityDTO(day: date.day, startTime: date.startTime, endTime: date.endTime)
                    dates.append(dateDTO)
                }
                vc.dates = dates
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
