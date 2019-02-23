//
//  CreateUpdateTimeSheetViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 2/23/19.
//  Copyright © 2019 chymps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import DropDown
import JGProgressHUD
import AFDateHelper

class CreateUpdateTimeSheetViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var startTime: SkyFloatingLabelTextField!
    @IBOutlet private weak var endTime: SkyFloatingLabelTextField!
    
    @IBOutlet weak var monthSelection: BaseDropdownButton!
    
    let dropDown = DropDown()
    var dates = [Date]()
    var selectedDate: Date?
    
    var selectedWeek = [[String:Any]]()
//    var selectedDay: String?
    
    private let dropdownImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_dropdown")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var startTimePicker: UIDatePicker!
    private var endTimePicker: UIDatePicker!
    
    var toast: JYToast!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        view.backgroundColor = Constants.Colors.primaryGreenColor
        
        self.toast = JYToast()
        
        self.setupDropdown()
        
        self.monthSelection.titleLabel.text = self.getMonths()[3]
        
        self.startTime.text = "00:00"
        self.endTime.text = "00:00"
        
        let date = Date()
        self.dates = self.generateDatesArrayBetweenTwoDates(startDate: date, endDate: date.endOfMonth())
        self.collectionView.reloadData()
        
        startTimePicker = UIDatePicker()
        startTimePicker.datePickerMode = .time
        startTimePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        startTimePicker.addTarget(self, action: #selector(startTime(_:)), for: .valueChanged)
        
        endTimePicker = UIDatePicker()
        endTimePicker.datePickerMode = .time
        endTimePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        endTimePicker.addTarget(self, action: #selector(endTime(_:)), for: .valueChanged)
        
        startTime.placeholder = "Start Time"
        startTime.title = "Start Time"
        startTime.font = AppConstants.shared.textFieldFont
        startTime.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        startTime.lineColor = AppConstants.shared.primaryBlueColor
        startTime.selectedLineColor = AppConstants.shared.primaryBlueColor
        startTime.selectedTitleColor = AppConstants.shared.primaryBlueColor
        startTime.translatesAutoresizingMaskIntoConstraints = false
        startTime.rightView = dropdownImage
        startTime.inputView = startTimePicker
        startTime.delegate = self
        startTime.text = Date().toString(format: DateFormatType.custom("HH:mm"))
        
        endTime.placeholder = "End Time"
        endTime.title = "End Time"
        endTime.font = AppConstants.shared.textFieldFont
        endTime.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        endTime.lineColor = AppConstants.shared.primaryBlueColor
        endTime.selectedLineColor = AppConstants.shared.primaryBlueColor
        endTime.selectedTitleColor = AppConstants.shared.primaryBlueColor
        endTime.translatesAutoresizingMaskIntoConstraints = false
        endTime.rightView = dropdownImage
        endTime.inputView = endTimePicker
        endTime.delegate = self
    }
    
    func setupDropdown() {
        dropdownImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        dropdownImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        dropDown.anchorView = self.monthSelection
        dropDown.dataSource = self.getMonths()
        dropDown.bottomOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        DropDown.startListeningToKeyboard()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.monthSelection.titleLabel.text = item
            
            let strMonth = String(item.split(separator: " ").first ?? "")
            let month = self.getMonthNumber(strMonth)
            let year = Int(item.split(separator: " ").last ?? "") ?? 0
            
            let dateComponents = DateComponents(year: year, month: month) //, day: 23)
            let calendar = Calendar.current
            let date = calendar.date(from: dateComponents)!
            
            if date.compare(.isThisMonth) {
                //let date = Date()
                let dateArr = self.generateDatesArrayBetweenTwoDates(startDate: date, endDate: date.endOfMonth())
                if dateArr.count == 0 {
                    self.dates = [Date()]
                } else {
                    self.dates = dateArr
                }
            } else {
                self.dates = self.getAllDates(month: month, year: year)
            }
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
        }
        
        self.monthSelection.completion = {
            self.dropDown.show()
        }
        
    }
    
    @objc func endTime(_ sender: UIDatePicker) {
        let date = sender.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let enTime = formatter.string(from: date)
        endTime.text = enTime
    }
    
    @objc func startTime(_ sender: UIDatePicker) {
        let date = sender.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let strtTime = formatter.string(from: date)
        startTime.text = strtTime
        if endTime.text == "End Time" {
            endTime.text = strtTime
        }
        endTimePicker.minimumDate = date
    }
    
    @IBAction func add(_ sender: UIButton) {
        if !(endTimePicker.date > startTimePicker.date) {
            AlertService.shared.alert(in: self, "End time must be greater than Start time")
            return
        }
        if let date = self.selectedDate {
            
            let strDate = date.toString(format: DateFormatType.custom("E d"))
            let day = String(strDate.split(separator: " ").first ?? "")
            let date = String(strDate.split(separator: " ").last ?? "")
            let month = self.monthSelection.titleLabel.text ?? ""
            
            var week = [String:Any]()
            week["day"] = day
            week["date"] = date
            week["start_time"] = self.startTime.text
            week["end_time"] = self.endTime.text
            week["month"] = self.monthSelection.titleLabel.text ?? ""
            let completeDate = "\(date) \(String(describing: month))"
            week["complete_date"] = completeDate
            
            if let index = self.selectedWeek.firstIndex(where: { $0["complete_date"] as? String == completeDate }) {
                self.selectedWeek[index] = week
            } else {
                self.selectedWeek.append(week)
            }
            self.tableView.reloadData()
        } else {
            AlertService.shared.alert(in: self, "Select Day")
        }
    }
}

extension CreateUpdateTimeSheetViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeekTableViewCell", for: indexPath) as! WeekTableViewCell
        
        let week = self.selectedWeek[indexPath.row]
//        let day = week["day"] as? String ?? ""
        let date = week["date"] as? String ?? ""
        let month = week["month"] as? String ?? ""
        let startTime = week["start_time"] as? String ?? ""
        let endTime = week["end_time"] as? String ?? ""
        cell.day.text = week["complete_date"] as? String ?? "" // "\(date) \(month)"
        cell.time.text = "\(startTime) - \(endTime)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let remove = UITableViewRowAction(style: .default, title: "Remove") { (action, index) in
            
            self.selectedWeek.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        
        remove.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        
        return [remove]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension CreateUpdateTimeSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCellID", for: indexPath) as! DateCollectionViewCell
        cell.updateData(date: self.dates[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(dates[indexPath.row])
        selectedDate = dates[indexPath.row]
        
    }
    
}

extension CreateUpdateTimeSheetViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == startTime {
            endTime.resignFirstResponder()
            startTime.becomeFirstResponder()
        } else if textField == endTime {
            startTime.resignFirstResponder()
            endTime.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case startTime:
            if endTimePicker.date > startTimePicker.date {
                self.startTime.text = startTimePicker.date.toString(format: DateFormatType.custom("HH:mm"))
            }
        case endTime:
            
            if endTimePicker.date > startTimePicker.date {
                self.endTime.text = endTimePicker.date.toString(format: DateFormatType.custom("HH:mm"))
            }
            
        default:
            break
        }
    }
}

extension CreateUpdateTimeSheetViewController {
    
    //Dropdown datasource
    func getMonths() -> [String] {
        let date = Date()
        
        var stringDate = [String]()
        for i in -3..<3 {
            let dt = date.addMonth(n: i)
            let stringDt = dt.toString(format: DateFormatType.custom("MMMM yyyy"))
            stringDate.append(stringDt)
        }
        return stringDate
        
    }
    
    func getMonthNumber(_ month: String) -> Int {
        switch month {
        case "January":
            return 1
        case "February":
            return 2
        case "March":
            return 3
        case "April":
            return 4
        case "May":
            return 5
        case "June":
            return 6
        case "July":
            return 7
        case "August":
            return 8
        case "September":
            return 9
        case "October":
            return 10
        case "November":
            return 11
        case "December":
            return 12
        default:
            return 0
        }
    }
    
    //get dat array from - to
    func generateDatesArrayBetweenTwoDates(startDate: Date , endDate:Date) ->[Date] {
        var datesArray: [Date] =  [Date]()
        var startDate = startDate
        let calendar = Calendar.current
        
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        
        while startDate <= endDate {
            datesArray.append(startDate)
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
            
        }
        return datesArray
    }
    
    // get all days for a specific month
    func getAllDates(month: Int, year: Int) -> [Date] {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        var arrDates = [Date]()
        for day in 1...numDays {
            let dateString = "\(year) \(month) \(day)"
            if let date = formatter.date(from: dateString) {
                arrDates.append(date)
            }
        }
        
        return arrDates
    }
    
}
