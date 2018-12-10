//
//  TimesheetViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 12/10/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class TimesheetViewController: UIViewController {
    
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
        let date =  dateFormatter.date(fromSwapiString: (self.timeSheetData?.timesheets?.first?.date!)!)
        
        self.weekView.setupCalendar(numOfDays: 7, setDate: date!, allEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: self.scheduleTimes()))
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        JZWeekViewHelper.viewTransitionHandler(to: size, weekView: self.weekView)
    }
    
    private func scheduleTimes() -> [DefaultEvent] {
        let dateFormatter = DateFormatter()
        var schedules = [DefaultEvent]()
        for item in self.timeSheetData!.timesheets! {

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

//
class AllDayEvent: JZAllDayEvent {

    var location: String
    var title: String


    init(id: String, title: String, startDate: Date, endDate: Date, location: String, isAllDay: Bool) {
        self.location = location
        self.title = title

        // If you want to have you custom uid, you can set the parent class's id with your uid or UUID().uuidString (In this case, we just use the base class id)
        super.init(id: id, startDate: startDate, endDate: endDate, isAllDay: isAllDay)
    }

    override func copy(with zone: NSZone?) -> Any {
        return AllDayEvent(id: id, title: title, startDate: startDate, endDate: endDate, location: location, isAllDay: isAllDay)
    }
}

extension DateFormatter {
    func date(fromSwapiString dateString: String) -> Date? {
        // SWAPI dates look like: "2014-12-10T16:44:31.486000Z"
        self.dateFormat = "dd-MM-yyyy"
        self.timeZone = TimeZone(abbreviation: getCurrentTimeZone())
        self.locale = Locale(identifier: "en_US_POSIX")
        return self.date(from: dateString)
    }

    func getCurrentTimeZone() -> String{
        return String (TimeZone.current.identifier)
    }
}


extension Date {
    func add(component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }
}
