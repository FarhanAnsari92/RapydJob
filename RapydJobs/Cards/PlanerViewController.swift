//
//  PlanerViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 12/11/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import JZCalendarWeekView
import JGProgressHUD
import ObjectMapper

class PlanerViewController: UIViewController {
    
    @IBOutlet weak var weekView: DefaultWeekView!
    
    private let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        return hud
    }()
    
    var timeSheetData: TimesheetResponseModel?
    
    var dropDownData = [JobsDropDownItem]();
    var data = [EmployerJobsDropdownResponse]();
    var selectedJob: JobsDropDownItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Timesheet"
        self.view.backgroundColor = Constants.Colors.primaryGreenColor
        self.setupView()
        self.setupWeekView()
        
    }
    
    func setupView() {
        let filterBtn: UIButton = UIButton(type: UIButtonType.custom)
        filterBtn.setImage(UIImage(named: "ic_filter")?.withRenderingMode(.alwaysOriginal), for: .normal)
        filterBtn.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        filterBtn.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let filterBarBtn = UIBarButtonItem(customView: filterBtn)
        self.navigationItem.rightBarButtonItem = filterBarBtn
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
    
    private func getData(jobId: String = "") {
        if AppContainer.shared.user.user?.accountType == "jobseeker" {
            hud.show(in: view)
            MatchesAPISevice.shared.getJobseekerMatches(limit: "20") { (jobMatches, error) in
                self.hud.dismiss(animated: true)
                if let err = error {
                    print("Error : ", err)
                } else {
                    
                    print(jobMatches)
                    
                }
            }
        } else {
            hud.show(in: view)
            MatchesAPISevice.shared.getEmployerMatches(jobId: jobId, limit: "20") { (matches, error) in
                self.hud.dismiss(animated: true)
                if let err = error {
                    print("Error : ", err)
                } else {
                    
                    print(matches)
                    
                }
            }
        }
    }
    
    func setupWeekView() {
        
        weekView.updateFlowLayout(JZWeekViewFlowLayout(hourHeight: 50, rowHeaderWidth: 50, columnHeaderHeight: 50, hourGridDivision: JZHourGridDivision.noneDiv))
        let dateFormatter = DateFormatter()
        guard let timesheet = self.timeSheetData else {
            self.weekView.setupCalendar(numOfDays: 7, setDate: Date(), allEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: self.scheduleTimes()))
            return
        }
        let date =  dateFormatter.date(fromSwapiString: (timesheet.timesheets?.first?.date!)!)
        
        self.weekView.setupCalendar(numOfDays: 7, setDate: date!, allEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: self.scheduleTimes()))
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        JZWeekViewHelper.viewTransitionHandler(to: size, weekView: self.weekView)
    }
    
    private func scheduleTimes() -> [DefaultEvent] {
        let dateFormatter = DateFormatter()
        var schedules = [DefaultEvent]()
        guard let timesheet = self.timeSheetData else {
            return [DefaultEvent]()
        }
        for item in timesheet.timesheets! {
            
            let date =  dateFormatter.date(fromSwapiString: item.date!) //.datefrom //.date(from: item.date!)
            let startTimeSplit = item.startTime?.components(separatedBy: ":")
            let endTimeSplit = item.endTime?.components(separatedBy: ":")
            
            let start = date!.add(component: .hour, value: Int(startTimeSplit![0])!).add(component: .minute, value: Int(startTimeSplit![1])!)
            let end = date!.add(component: .hour, value: Int(endTimeSplit![0])!).add(component: .minute, value: Int(endTimeSplit![1])!)
            
            let event = DefaultEvent(id: "1", title: "", startDate: start, endDate: end, location: "")
            schedules.append(event)
            
        }
        
        return schedules
    }
}
