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
            print(jobModel?.toJSON())
            
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

extension JobDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "information-cell") as! BasicInformationTableViewCell
            
            cell.timeLabel.text = self.jobModel?.organizationName ?? ""
            
            let start = (self.jobModel?.dates?.last)?.startTime ?? ""
            let endTime = (self.jobModel?.dates?.last)?.endTime ?? ""
            cell.budgetLabel.text = "\(start) - \(endTime)"
            cell.locationLabel.text = self.jobModel?.address?.address ?? ""
            
            if let _ = self.item {
                cell.timeLabel.text = item?.subtitle ?? ""
                let start = (item?.dates?.first)?.startTime ?? ""
                let endTime = (item?.dates?.first)?.endTime ?? ""
                cell.budgetLabel.text = "\(start) - \(endTime)"
                cell.locationLabel.text = item?.location ?? ""
            } else if let rwItm = self.rawItem {
                cell.timeLabel.text = rwItm["organization_name"] as? String ?? ""
                if let dt = rwItm["dates"] as? [[String:Any]] {
                    let start = dt.first?["start_time"] as? String ?? ""
                    let endTime = dt.first?["end_time"] as? String ?? ""
                    cell.budgetLabel.text = "\(start) - \(endTime)"
                }
                cell.locationLabel.text = rwItm["address"] as? String ?? ""
            } else if let jobItm = self.jobMatch {
                cell.timeLabel.text = self.jobMatch?.jobOwner.organization.organizationName
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "description-cell") as! DescriptionTableViewCell
            
            cell.descriptionTextView.text = self.jobModel?.description ?? ""
            
            if let _ = self.item {
                cell.descriptionTextView.text = item?.description ?? ""
            } else if let rwItm = self.rawItem {
                cell.descriptionTextView.text = rwItm["description"] as? String ?? ""
            } else if let jobItm = self.jobMatch {
                cell.descriptionTextView.text = self.jobMatch?.descriptionField
            }
            
            return cell
        }
    }
}
