//
//  RescheduleInterviewViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/3/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import DropDown
import JGProgressHUD
import AFDateHelper

class RescheduleInterviewViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var jobSelection: SkyFloatingLabelTextField!
    @IBOutlet private weak var candidateSelection: SkyFloatingLabelTextField!
    @IBOutlet private weak var interviewStartTimeSelection: SkyFloatingLabelTextField!
    @IBOutlet private weak var interviewEndTimeSelection: SkyFloatingLabelTextField!
    
    @IBOutlet weak var monthSelection: BaseDropdownButton!
    @IBOutlet weak var scheduleButton: BaseButton!
    
    var completion: (() -> Void)?
    
    private var startTimePicker: UIDatePicker!
    private var endTimePicker: UIDatePicker!
    var selectedDate: Date?
    
    let dropDown = DropDown()
    var dates = [Date]()
    var date: Date?
    var jobId: Int!
    var jobSeekerId: Int!
    
    var interviewModel: InterviewModel?
    
    private let dropdownImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_dropdown")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        return hud
    }()
    
    var toast: JYToast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toast = JYToast()
        
        
        self.setup()
        
        
    }
    
    //MARK: DropDown handler
    private func setup() {
        
        title = "Invite For Interview"
        view.backgroundColor = Constants.Colors.primaryGreenColor
        
        dropdownImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        dropdownImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
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
        
        dropdownImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        dropdownImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        scheduleButton.setup(title: "Schedule")
        
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
        
        scheduleButton.setup(title: "Schedule")
        
        jobSelection.text = self.interviewModel?.jobTitle ?? ""
        jobSelection.placeholder = "Job Title"
        jobSelection.isEnabled = false
        jobSelection.title = "Job Title"
        jobSelection.font = AppConstants.shared.textFieldFont
        jobSelection.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        jobSelection.lineColor = AppConstants.shared.primaryBlueColor
        jobSelection.selectedLineColor = AppConstants.shared.primaryBlueColor
        jobSelection.selectedTitleColor = AppConstants.shared.primaryBlueColor
        
        jobSelection.translatesAutoresizingMaskIntoConstraints = false
        
        candidateSelection.text = self.interviewModel?.fullname ?? ""
        candidateSelection.placeholder = "Candidate Name"
        candidateSelection.isEnabled = false
        candidateSelection.title = "Candidate Name"
        candidateSelection.font = AppConstants.shared.textFieldFont
        candidateSelection.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        candidateSelection.lineColor = AppConstants.shared.primaryBlueColor
        candidateSelection.selectedLineColor = AppConstants.shared.primaryBlueColor
        candidateSelection.selectedTitleColor = AppConstants.shared.primaryBlueColor
        candidateSelection.translatesAutoresizingMaskIntoConstraints = false
        
        interviewStartTimeSelection.placeholder = "Start Time"
        interviewStartTimeSelection.title = "Start Time"
        interviewStartTimeSelection.font = AppConstants.shared.textFieldFont
        interviewStartTimeSelection.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        interviewStartTimeSelection.lineColor = AppConstants.shared.primaryBlueColor
        interviewStartTimeSelection.selectedLineColor = AppConstants.shared.primaryBlueColor
        interviewStartTimeSelection.selectedTitleColor = AppConstants.shared.primaryBlueColor
        interviewStartTimeSelection.translatesAutoresizingMaskIntoConstraints = false
        interviewStartTimeSelection.rightView = dropdownImage
        interviewStartTimeSelection.inputView = startTimePicker
        interviewStartTimeSelection.delegate = self
        interviewStartTimeSelection.text = self.interviewModel?.startTime ?? ""
        
        interviewEndTimeSelection.placeholder = "End Time"
        interviewEndTimeSelection.title = "End Time"
        interviewEndTimeSelection.font = AppConstants.shared.textFieldFont
        interviewEndTimeSelection.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        interviewEndTimeSelection.lineColor = AppConstants.shared.primaryBlueColor
        interviewEndTimeSelection.selectedLineColor = AppConstants.shared.primaryBlueColor
        interviewEndTimeSelection.selectedTitleColor = AppConstants.shared.primaryBlueColor
        interviewEndTimeSelection.translatesAutoresizingMaskIntoConstraints = false
        interviewEndTimeSelection.rightView = dropdownImage
        interviewEndTimeSelection.inputView = endTimePicker
        interviewEndTimeSelection.delegate = self
        interviewEndTimeSelection.text = self.interviewModel?.endTime ?? ""
        
        if let strDate = self.interviewModel?.date {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let date = dateFormatter.date(from: strDate)
            
            self.selectedDate = date
            
            let day = String((strDate.split(separator: "-")).first ?? "")
            let month = String((strDate.split(separator: "-"))[1])
            let year = String((strDate.split(separator: "-")).last ?? "")
            
            
            
            var dc = DateComponents()
            dc.day = Int(day)
            dc.month = Int(month)
            dc.year = Int(year)
            
            let calender = Calendar.current
            let sMonth = calender.component(.month, from: self.selectedDate!)
            let sYear = calender.component(.year, from: self.selectedDate!)
            
            print(sMonth)
            print(sYear)
            print(calender.component(.year, from: self.selectedDate!))
            
            
            if let date = calender.date(from: dc) {
                self.selectedDate = date
                if date.compare(.isThisMonth) {
                    let dateArr = self.generateDatesArrayBetweenTwoDates(startDate: Date(), endDate: date.endOfMonth())
                    if dateArr.count == 0 {
                        self.dates = [Date()]
                    } else {
                        self.dates = dateArr
                    }
                } else {
                    self.dates = self.getAllDates(month: Int(month)!, year: Int(year)!)
                }
                self.monthSelection.titleLabel.text = date.toString(format: DateFormatType.custom("MMMM yyyy"))
                
                let df = DateFormatter()
                df.dateFormat = "dd-MM-yyyy HH:mm"
                df.timeZone = TimeZone(abbreviation: "UTC")
                
                let cmpltstrtDat = "\(strDate) \((self.interviewModel?.startTime!)!)"
                let cmpltendDat = "\(strDate) \((self.interviewModel?.endTime!)!)"
                
                print(cmpltstrtDat)
                print(cmpltendDat)
                
                let strDt = df.date(from: cmpltstrtDat)
                let endDt = df.date(from: cmpltendDat)
                
                print(strDt)
                print(endDt)
                
                self.startTimePicker.date = strDt!
                self.endTimePicker.date = endDt! // self.interviewModel?.startTime
                
                self.collectionView.reloadData()
                
                self.collectionView.scrollToItem(at: IndexPath(item: Int(day) ?? 0, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            }
        }
    }
    
    @objc func endTime(_ sender: UIDatePicker) {
        let date = sender.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let endTime = formatter.string(from: date)
        interviewEndTimeSelection.text = endTime
    }
    
    @objc func startTime(_ sender: UIDatePicker) {
        let date = sender.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let startTime = formatter.string(from: date)
        interviewStartTimeSelection.text = startTime
        if interviewEndTimeSelection.text == "End Time" {
            interviewEndTimeSelection.text = startTime
        }
        endTimePicker.minimumDate = date
    }
    
    @IBAction func callScheduleAPI() {
        
        if !(endTimePicker.date > startTimePicker.date) {
            AlertService.shared.alert(in: self, "End time must be greater than Start time")
            return
        }
        
        if interviewStartTimeSelection.text == "Start Time" {
            AlertService.shared.alert(in: self, "Invalid start time")
            return
        }
        if interviewEndTimeSelection.text == "End Time" {
            AlertService.shared.alert(in: self, "Invalid end time")
            return
        }
        guard let date = selectedDate else {
            AlertService.shared.alert(in: self, "Invalid date")
            return
        }
        
        var params = [String:Any]()
        params["user_id"] = self.jobSeekerId
        params["job_id"] = self.jobId
        params["interview_status"] = "scheduled"
        params["start_time"] = interviewStartTimeSelection.text
        params["end_time"] = interviewEndTimeSelection.text
        params["date"] = date.toString(format: DateFormatType.custom("dd-MM-yyyy"))
        
        let id = self.interviewModel?.interviewId ?? 0
        print(id)
        // Loader
        print(params)
        hud.show(in: view)
        
        _ = APIClient.callAPI(request: .updateInterview(interviewId: id, param: params), onSuccess: { (dictionary) in
            self.hud.dismiss(animated: true)
            self.completion?()
            self.navigationController?.popViewController(animated: true)
            print(dictionary)
        }) { (errorDictionary, _) in
            self.hud.dismiss(animated: true)
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
            print(errorDictionary)
        }
    }
    
}

extension RescheduleInterviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCellID", for: indexPath) as! DateCollectionViewCell

        if let _ = self.interviewModel {
            cell.isSelected = (self.selectedDate?.compare(DateComparisonType.isSameDay(as: self.dates[indexPath.row])))!
        }
        
        
        cell.updateData(date: self.dates[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = dates[indexPath.row]
        collectionView.reloadData()
    }
    
}

extension RescheduleInterviewViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == interviewStartTimeSelection {
            interviewEndTimeSelection.resignFirstResponder()
            interviewStartTimeSelection.becomeFirstResponder()
        } else if textField == interviewEndTimeSelection {
            interviewStartTimeSelection.resignFirstResponder()
            interviewEndTimeSelection.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case interviewStartTimeSelection:
            if endTimePicker.date > startTimePicker.date {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                formatter.timeZone = TimeZone(abbreviation: "UTC")
                let strDate = formatter.string(from: startTimePicker.date)
                self.interviewStartTimeSelection.text = strDate // startTimePicker.date.toString(format: DateFormatType.custom("HH:mm"))
            }
        case interviewEndTimeSelection:
            
            if endTimePicker.date > startTimePicker.date {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                formatter.timeZone = TimeZone(abbreviation: "UTC")
                let endDate = formatter.string(from: endTimePicker.date)
                
                self.interviewEndTimeSelection.text = endDate // endTimePicker.date.toString(format: DateFormatType.custom("HH:mm"))
            }
            
        default:
            break
        }
    }
}

extension RescheduleInterviewViewController {
    
    //Dropdown datasource
    func getMonths() -> [String] {
        let date = Date()
        
        var stringDate = [String]()
        for i in 0..<12 {
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
