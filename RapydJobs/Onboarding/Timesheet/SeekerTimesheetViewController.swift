//
//  SeekerTimesheetViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 12/11/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class SeekerTimesheetViewController: UIViewController {

    @IBOutlet weak var weekView: DefaultWeekView!
    
    var timeSheetData: TimesheetResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(timeSheetData)
        
        self.title = "Timesheet"
        self.view.backgroundColor = Constants.Colors.primaryGreenColor // UIColor(white: 0.99, alpha: 0.8)
        
        self.setupWeekView()
    }
    
    //    var events = [JZBaseEvent]()
    
    func setupWeekView() {
        
        weekView.updateFlowLayout(JZWeekViewFlowLayout(hourHeight: 50, rowHeaderWidth: 50, columnHeaderHeight: 50, hourGridDivision: JZHourGridDivision.noneDiv))
        let dateFormatter = DateFormatter()
        
        guard let timesheet = self.timeSheetData else {
            self.weekView.setupCalendar(numOfDays: 7, setDate: Date(), allEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: self.scheduleTimes()))
            return
        }
        
        let startDate =  dateFormatter.date(fromSwapiString: (self.timeSheetData?.timesheets?.first?.date!)!)
        
        let lastDate =  dateFormatter.date(fromSwapiString: (self.timeSheetData?.timesheets?.last?.date!)!)
        
        self.weekView.setupCalendar(numOfDays: 7, setDate: startDate!, allEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: self.scheduleTimes()), scrollType: .pageScroll, scrollableRange: (startDate: startDate, endDate: lastDate))
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
