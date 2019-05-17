//
//  ShowTimeSheetViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 3/31/19.
//  Copyright © 2019 chymps. All rights reserved.
//

import UIKit
import JZCalendarWeekView
import AFDateHelper

class ShowTimeSheetViewController: UIViewController {
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var weekView: DefaultWeekView!
    
    var dates = [AvailabilityDTO]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shift Timing"
        self.view.backgroundColor = Constants.Colors.primaryGreenColor
        
        setupWeekView()
    }

    func setupWeekView() {
        
        weekView.updateFlowLayout(JZWeekViewFlowLayout(hourHeight: 50, rowHeaderWidth: 50, columnHeaderHeight: 50, hourGridDivision: JZHourGridDivision.noneDiv))
        let dateFormatter = DateFormatter()
        
        let startDate =  dateFormatter.date(fromSwapiString: (""))
        let lastDate =  dateFormatter.date(fromSwapiString: (""))
        
        let week = Calendar.current.date(byAdding: .hour, value: 0, to: Date())!
        
        self.weekView.setupCalendar(numOfDays: 7, setDate: Date(), allEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: [DefaultEvent]()), scrollType: .pageScroll, scrollableRange: (startDate: Date(), endDate: week))
        
        self.weekView.setupCalendar(numOfDays: 7, setDate: Date(), allEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: scheduleTimes()), scrollType: .pageScroll, scrollableRange: (startDate: Date(), endDate: week))
        

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        JZWeekViewHelper.viewTransitionHandler(to: size, weekView: self.weekView)
    }
    
    private func scheduleTimes() -> [DefaultEvent] {
        
        let dateArray = self.weekView.getDatesInCurrentPage(isScrolling: false)
        
        print(self.dates)
        
        let dateFormatter = DateFormatter()
        var schedules = [DefaultEvent]()
        for item in self.dates {
            print(item)
            for (index, weekDate) in dateArray.enumerated() {
                print(weekDate)
                
                let strDate = weekDate.toString(format: .standard, timeZone: .local, locale: .current)
                
                let newDt = Date(fromString: strDate, format: .standard, timeZone: .local, locale: .current)
//
//                let df = DateFormatter()
//                df.locale = Locale(identifier: "en_US_POSIX")
//                df.timeZone = TimeZone(abbreviation: "GMT+5:00") // TimeZone(abbreviation: "UTC")
//                df.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
//
//                let newDt = df.date(from: strDate)
                print(newDt)
                
                let weekday = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: weekDate) - 1].lowercased()
                if weekday == item.day {
                    let startTimeSplit = item.startTime.components(separatedBy: ":")
                    let endTimeSplit = item.endTime.components(separatedBy: ":")
                    
                    let start = weekDate.add(component: .hour, value: Int(startTimeSplit[0])!).add(component: .minute, value: Int(startTimeSplit[1])!)
                    let end = weekDate.add(component: .hour, value: Int(endTimeSplit[0])!).add(component: .minute, value: Int(endTimeSplit[1])!)
                    let event = DefaultEvent(id: "1", title: "", startDate: start, endDate: end, location: "")
                    schedules.append(event)
                    
                    print("----------------")
                    break
                }
            }
        }
        
        return schedules
    }
}

extension ShowTimeSheetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = self.dates[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowTimeSheetTableViewCellID") as! ShowTimeSheetTableViewCell
        cell.lblDay.text = date.day.capitalized
        cell.lblTime.text = "\(date.startTime) - \(date.endTime)"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }


}

extension Date {
    
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.index(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = searchWeekdayIndex
        
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
}

// MARK: Helper methods
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .Next:
                return .forward
            case .Previous:
                return .backward
            }
        }
    }
}

