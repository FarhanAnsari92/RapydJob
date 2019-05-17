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
    
    var timePlannerData = [PlannerDataResponseModel]();
    var interviewPlannerData = [InterviewPlannerDataResponseModel]();
    
    var dropDownData = [OrganizationHireDropdownModel]();
    var selectedJob: OrganizationHireDropdownModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Planner"
        self.view.backgroundColor = Constants.Colors.primaryGreenColor
        self.setupView()
        
        weekView.updateFlowLayout(JZWeekViewFlowLayout(hourHeight: 50, rowHeaderWidth: 50, columnHeaderHeight: 50, hourGridDivision: JZHourGridDivision.noneDiv))
        
        self.setupWeekView()
        self.getHiderDropDown()
        
    }
    
    func getHiderDropDown() {
        _ = APIClient.callAPI(request: .jobseekerHireDropdown, onSuccess: { (dictionary) in
            print(dictionary)
            
            if let data = dictionary["data"] as? [[String:Any]] {
                self.dropDownData = Mapper<OrganizationHireDropdownModel>().mapArray(JSONArray: data)
            }
            self.getPlannerData()

        }, onFailure: { (errorDictionary, _) in
            print(errorDictionary)
        })
    }
    
    func getPlannerData(id: Int? = nil) {
        _ = APIClient.callAPI(request: .jobseekerPlanner(id: id), onSuccess: { (dictionary) in
            
            print(dictionary)
            if let data = dictionary["time_planner"] as? [[String:Any]] , data.count > 0 {
                self.timePlannerData = Mapper<PlannerDataResponseModel>().mapArray(JSONArray: data)
                print(self.timePlannerData.toJSON())
            }
            
            if let data = dictionary["interview_planner"] as? [[String:Any]] , data.count > 0 {
                self.interviewPlannerData = Mapper<InterviewPlannerDataResponseModel>().mapArray(JSONArray: data)
                print(self.interviewPlannerData.toJSON())
            }
            
            self.setupWeekView()
            
        }, onFailure: { (errorDictionary, _) in
            print(errorDictionary)
        })
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
            
            actionSheet.addAction(UIAlertAction(title: "All", style: .default, handler: { (action) in
               self.getPlannerData()
                actionSheet.dismiss(animated: true, completion: nil)
            }))
            
            for i in 0..<self.dropDownData.count {
                actionSheet.addAction(UIAlertAction(title: self.dropDownData[i].jobName, style: .default, handler: { (action) in
                    
                    self.selectedJob = self.dropDownData[i]
                    self.timePlannerData.removeAll()
                    self.interviewPlannerData.removeAll()
                    self.getPlannerData(id: self.dropDownData[i].jobId)
                    actionSheet.dismiss(animated: true, completion: nil)
                    
                }))
            }
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func setupWeekView() {
        
        

        self.weekView.setupCalendar(numOfDays: 3, setDate: Date(), allEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: self.scheduleTimes()))

        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        JZWeekViewHelper.viewTransitionHandler(to: size, weekView: self.weekView)
    }
    
    private func scheduleTimes() -> [DefaultEvent] {
        let dateFormatter = DateFormatter()
        var schedules = [DefaultEvent]()
        
        for item in self.timePlannerData {
            
            let date =  dateFormatter.date(fromSwapiString: item.dayOfMonth!) //.datefrom //.date(from: item.date!)
            let startTimeSplit = item.startTime?.components(separatedBy: ":")
            let endTimeSplit = item.endTime?.components(separatedBy: ":")
            
            let start = date!.add(component: .hour, value: Int(startTimeSplit![0])!).add(component: .minute, value: Int(startTimeSplit![1])!)
            let end = date!.add(component: .hour, value: Int(endTimeSplit![0])!).add(component: .minute, value: Int(endTimeSplit![1])!)
            
            let event = DefaultEvent(id: "1", title: item.jobName ?? "", startDate: start, endDate: end, location: "")
            schedules.append(event)
            
        }
        
        for item in self.interviewPlannerData {
            
            let date =  dateFormatter.date(fromSwapiString: item.dayOfMonth!) //.datefrom //.date(from: item.date!)
            let startTimeSplit = item.startTime?.components(separatedBy: ":")
            let endTimeSplit = item.endTime?.components(separatedBy: ":")
            
            let start = date!.add(component: .hour, value: Int(startTimeSplit![0])!).add(component: .minute, value: Int(startTimeSplit![1])!)
            let end = date!.add(component: .hour, value: Int(endTimeSplit![0])!).add(component: .minute, value: Int(endTimeSplit![1])!)
            
            let event = DefaultEvent(id: "1", title: item.jobName ?? "", startDate: start, endDate: end, location: "Interview Schedule")
            schedules.append(event)
            
        }
        
        return schedules
    }
}
