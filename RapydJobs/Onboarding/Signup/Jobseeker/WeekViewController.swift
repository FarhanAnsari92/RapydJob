//
//  WeekViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 12/3/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class WeekViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startTime: SkyFloatingLabelTextField! {
        didSet {
            startTime.placeholder = "Start Time"
            startTime.title = "Start Time"
            startTime.font = AppConstants.shared.textFieldFont
            startTime.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            startTime.lineColor = AppConstants.shared.primaryBlueColor
            startTime.selectedLineColor = AppConstants.shared.primaryBlueColor
            startTime.selectedTitleColor = AppConstants.shared.primaryBlueColor
        }
    }
    @IBOutlet weak var endTime: SkyFloatingLabelTextField!  {
        didSet {
            endTime.placeholder = "End Time"
            endTime.title = "End Time"
            endTime.font = AppConstants.shared.textFieldFont
            endTime.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            endTime.lineColor = AppConstants.shared.primaryBlueColor
            endTime.selectedLineColor = AppConstants.shared.primaryBlueColor
            endTime.selectedTitleColor = AppConstants.shared.primaryBlueColor
        }
    }
    
    
    var completion: (([[String:Any]]?) -> Void)?
    private var startTimePicker: UIDatePicker!
    private var endTimePicker: UIDatePicker!
    
    let days = [
        "monday",
        "tueday",
        "wednesday",
        "thursday",
        "friday",
        "saturday",
        "sunday",
    ]
    
    var selectedWeek = [[String:Any]]()
    
    var selectedDay: String?

    @objc func doneHandler() {
        completion?(self.selectedWeek)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add TimeSheet"
        view.backgroundColor = Constants.Colors.primaryGreenColor
        
        let doneBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneHandler))
        self.navigationItem.rightBarButtonItem = doneBarBtn
        
        self.startTime.text = "00:00"
        self.endTime.text = "00:00"
        
        startTimePicker = UIDatePicker()
        startTimePicker.datePickerMode = .time
        startTimePicker.timeZone = TimeZone(abbreviation: "UTC")
        startTimePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        startTimePicker.addTarget(self, action: #selector(startTime(_:)), for: .valueChanged)
        
        endTimePicker = UIDatePicker()
        endTimePicker.datePickerMode = .time
        endTimePicker.timeZone = TimeZone(abbreviation: "UTC")
        endTimePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        endTimePicker.addTarget(self, action: #selector(endTime(_:)), for: .valueChanged)
        
        startTime.delegate = self
        startTime.inputView = startTimePicker
        
        endTime.delegate = self
        endTime.inputView = endTimePicker
        
//        self.selectedWeek = [["end_time": "18:17", "day": "monday", "start_time": "16:17"], ["end_time": "20:17", "day": "thursday", "start_time": "17:17"]]
//        self.tableView.reloadData() // Working code
    }
    
    @IBAction func add(_ sender: UIButton) {
       
        if !(endTimePicker.date > startTimePicker.date) {
            AlertService.shared.alert(in: self, "End time must be greater than Start time")
            return
        }
        if let _ = self.selectedDay {
            var week = [String:Any]()
            week["day"] = self.selectedDay
            week["start_time"] = self.startTime.text
            week["end_time"] = self.endTime.text
            
            if let index = self.selectedWeek.firstIndex(where: { $0["day"] as? String == self.selectedDay }) {
                self.selectedWeek[index] = week
            } else {
                self.selectedWeek.append(week)
            }
            self.tableView.reloadData()
        } else {
            AlertService.shared.alert(in: self, "Select Day")
        }
    }
    
    @objc func endTime(_ sender: UIDatePicker) {
        self.setEndTime(date: sender.date)
    }
    
    @objc func startTime(_ sender: UIDatePicker) {
        self.setStartTime(date: sender.date)
    }
    
    func setEndTime(date: Date) {
        let date = date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let endTime = formatter.string(from: date)
        self.endTime.text = endTime
    }
    
    func setStartTime(date: Date) {
        let date = date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let startTime = formatter.string(from: date)
        self.startTime.text = startTime
        if self.endTime.text == "End Time" {
            self.endTime.text = startTime
        }
    }
}

extension WeekViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCellID", for: indexPath) as! DateCollectionViewCell
        let day = self.days[indexPath.row]
        
        cell.dayLabel.text = String(day.prefix(3))
        if let _ = self.selectedDay {
            cell.isSelected = self.selectedDay == self.days[indexPath.row]
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedDay = self.days[indexPath.row]
        
        if let index = self.selectedWeek.firstIndex(where: { $0["day"] as? String == self.selectedDay }) {
            let week = self.selectedWeek[index]
            self.startTime.text = week["start_time"] as? String ?? ""
            self.endTime.text = week["end_time"] as? String ?? ""
        } else {
            self.startTime.text = "00:00"
            self.endTime.text = "00:00"
        }
        
        collectionView.reloadData()
    }
    
}

extension WeekViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeekTableViewCell", for: indexPath) as! WeekTableViewCell
        
        let week = self.selectedWeek[indexPath.row]
        let day = week["day"] as? String ?? ""
        let startTime = week["start_time"] as? String ?? ""
        let endTime = week["end_time"] as? String ?? ""
        cell.day.text = day
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

extension WeekViewController: UITextFieldDelegate {
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
        if textField == self.startTime {
            self.setStartTime(date: self.startTimePicker.date)
        } else if textField == self.endTime {
            self.setEndTime(date: self.endTimePicker.date)
        }
    }
}
