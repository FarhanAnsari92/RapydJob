//
//  ShiftTimeViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 12/3/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import AFDateHelper
import SkyFloatingLabelTextField

class ShiftTimeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
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
    
    private var startTimePicker: UIDatePicker!
    private var endTimePicker: UIDatePicker!
    
    var dates = [Date]()
    var selectedDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Timesheet"
        view.backgroundColor = Constants.Colors.primaryGreenColor
        
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
        
        let calender = Calendar.current
        let sMonth = calender.component(.month, from: Date())
        let sYear = calender.component(.year, from: Date())
        
        self.dates = self.getAllDates(month: sMonth, year: sYear)
        self.collectionView.reloadData()
    }
    
    @objc func endTime(_ sender: UIDatePicker) {
        let date = sender.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let endTime = formatter.string(from: date)
        self.endTime.text = endTime
    }
    
    @objc func startTime(_ sender: UIDatePicker) {
        let date = sender.date
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

extension ShiftTimeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCellID", for: indexPath) as! DateCollectionViewCell
        
        if let _ = self.selectedDate {
            cell.isSelected = (self.selectedDate?.compare(DateComparisonType.isSameDay(as: self.dates[indexPath.row])))!
        }
        
        cell.updateData(date: self.dates[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = dates[indexPath.row]
        let formater = DateFormatter()
        formater.dateFormat = "E"
        formater.timeZone = TimeZone(abbreviation: "UTC")
        let strDate = formater.string(from: selectedDate!)
        print(strDate)
        
        collectionView.reloadData()
    }
    
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

extension ShiftTimeViewController: UITextFieldDelegate {
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
}
