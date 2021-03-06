//
//  JobseekerTimesheetViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/28/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import Segmentio
import ObjectMapper
import JGProgressHUD

class JobseekerTimesheetViewController: BaseViewController {
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var segmentControl: Segmentio!
    @IBOutlet weak var emptyPlaceholderView: EmptyPlaceholderView!
    var timesheets: [TimesheetResponseModel] = [TimesheetResponseModel]()
    
    private let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        return hud
    }()
    
    var toast: JYToast!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Timesheet"
        self.toast = JYToast()
        
        self.tbl.register(UINib(nibName: "TimeSheetJobseekerTableViewCell", bundle: nil), forCellReuseIdentifier: "TimeSheetJobseekerTableViewCellID")
        
        self.tbl.register(UINib(nibName: "TimesheetRejectTableViewCell", bundle: nil), forCellReuseIdentifier: "TimesheetRejectTableViewCellID")
        
        self.tbl.rowHeight = UITableViewAutomaticDimension
        self.tbl.estimatedRowHeight = 150
        
        self.setupSegment()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AppContainer.shared.notificationContainer.JobSeekerTimesheet {
            Helper.changeRedDot(type: "jobseeker_timesheet")
        }
        AppContainer.shared.notificationContainer.save(JobSeekerTimesheet: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        segmentControl.selectedSegmentioIndex = 0
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
        
        let segmentArray = [SegmentioItem(title: "APPROVED",image: UIImage(named: "")),
                            SegmentioItem(title: "PENDING",image: UIImage(named: "")),
                            SegmentioItem(title: "REJECTED",image: UIImage(named: ""))];
        
        segmentControl.setup(content: segmentArray, style: SegmentioStyle.onlyLabel, options: segmentioOptions)
        
        segmentControl.valueDidChange = { segmentio, segmentIndex in
            self.hud.dismiss(animated: true)
            self.timesheets.removeAll()
            self.emptyPlaceholderView.isHidden = true
            self.tbl.reloadData()
            if segmentIndex == 0 {
                self.getTimesheet(type: ["approve"])
            } else if segmentIndex == 1 {
                self.getTimesheet(type: ["update", "active"])
            } else {
                self.getTimesheet(type: ["reject", "amendment"])
            }
            
        }
    }
    
    func getTimesheet(type: [String]) {
        let param = ["status": type]
        
        hud.show(in: view)
        _ = APIClient.callAPI(request: .jobseekerTimesheet(param: param), onSuccess: { (dictionary) in
            self.hud.dismiss(animated: true)
            
            guard let data = dictionary["data"] as? [[String:Any]] else {
                return
            }
            
            self.timesheets = Mapper<TimesheetResponseModel>().mapArray(JSONArray: data)
            self.tbl.reloadData()
            
            if self.timesheets.count == 0 {
                self.showEmptyPlaceholderView()
            }
        
        }) { (errorDictionary, _) in
            self.hud.dismiss(animated: true)
            print(errorDictionary)
        }
        
    }
    
    private func showEmptyPlaceholderView() {
        if self.segmentControl.selectedSegmentioIndex == 0 {
            self.emptyPlaceholderView.message.text = "You don't have any approved timesheet at this moment"
        } else if self.segmentControl.selectedSegmentioIndex == 1 {
            self.emptyPlaceholderView.message.text = "You don't have any pending timesheet at this moment"
        } else {
            self.emptyPlaceholderView.message.text = "You don't have any rejected timesheet at this moment"
        }
        self.emptyPlaceholderView.isHidden = false
    }
    
    func change(status: String, timesheetId: Int, indexPath: IndexPath) {
        let param = ["status": status]
        print(param)
        print(timesheetId)
        hud.show(in: view)
        _ = APIClient.callAPI(request: .updateTimesheet(param: param, timesheetId: timesheetId), onSuccess: { (dictionary) in
            self.hud.dismiss(animated: true)
            print(dictionary)
            if let _ = dictionary["status"] as? String {
                self.timesheets.remove(at: indexPath.row)
                self.tbl.reloadData()
                if self.timesheets.count == 0 {
                    self.showEmptyPlaceholderView()
                }
            }
        }) { (errorDictionary, _) in
            self.hud.dismiss(animated: true)
            print(errorDictionary)
        }
        
    }
}

extension JobseekerTimesheetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timesheets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.segmentControl.selectedSegmentioIndex == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimesheetRejectTableViewCellID", for: indexPath) as! TimesheetRejectTableViewCell
            let timesheet = self.timesheets[indexPath.row]
            let id = timesheet.id ?? 0
            
            
            cell.approveBtn.isHidden = true
            cell.rejectBtn.isHidden = true
            cell.remakeBtn.isHidden = self.timesheets[indexPath.row].status != "amendment"
            cell.separator.isHidden = self.timesheets[indexPath.row].status != "amendment"
            cell.remake = { btn in
//                self.change(status: "update", timesheetId: id,indexPath: indexPath)
                let sb = UIStoryboard(name: "Timesheet", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "CreateUpdateTimeSheetViewControllerID") as! CreateUpdateTimeSheetViewController
                vc.timesheetResponseModel = self.timesheets[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.update(data: timesheet)
            
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSheetJobseekerTableViewCellID", for: indexPath) as! TimeSheetJobseekerTableViewCell
        let timesheet = self.timesheets[indexPath.row]
        cell.update(data: timesheet)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print(self.timesheets[indexPath.row].toJSON())
        let sb = UIStoryboard(name: "Timesheet", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TimesheetViewController") as! TimesheetViewController
        vc.timeSheetData = self.timesheets[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)

    }
}

extension JobseekerTimesheetViewController: Initializable {
    static var storyboardName: String {
        return UIStoryboard.Name.Timesheet.rawValue
    }
}
