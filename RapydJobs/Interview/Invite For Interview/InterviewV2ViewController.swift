//
//  InterviewV2ViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/1/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import DropDown
import JGProgressHUD
import AFDateHelper

class InterviewV2ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var jobSelection: SkyFloatingLabelTextField!
    @IBOutlet private weak var candidateSelection: SkyFloatingLabelTextField!
    @IBOutlet private weak var interviewStartTimeSelection: SkyFloatingLabelTextField!
    @IBOutlet private weak var interviewEndTimeSelection: SkyFloatingLabelTextField!
    
    @IBOutlet weak var monthSelection: BaseDropdownButton!
    @IBOutlet weak var scheduleButton: BaseButton!
    
    private var startTimePicker: UIDatePicker!
    private var endTimePicker: UIDatePicker!
    var selectedDate: Date?
    
    let dropDown = DropDown()
    var dates = [Date]()
    var jobId: Int!
    var jobTitle: String!
    var jobSeekerId: Int!
    var jobSeekerName: String!
    
    
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
        
        self.monthSelection.titleLabel.text = self.getMonths().first ?? ""
        
        let date = Date()
        self.dates = Constants.generateDatesArrayBetweenTwoDates(startDate: date, endDate: date.endOfMonth())
        self.collectionView.reloadData()
        
//        endTimePicker.minimumDate = date
        
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
            let month = Constants.getMonthNumber(strMonth)
            let year = Int(item.split(separator: " ").last ?? "") ?? 0
            
            let dateComponents = DateComponents(year: year, month: month) //, day: 23)
            let calendar = Calendar.current
            let date = calendar.date(from: dateComponents)!
            
            if date.compare(.isThisMonth) {
                //let date = Date()

                let dateArr = Constants.generateDatesArrayBetweenTwoDates(startDate: date, endDate: date.endOfMonth())

                if dateArr.count == 0 {
                    self.dates = [Date()]
                } else {
                    self.dates = dateArr
                }
            } else {
                self.dates = Constants.getAllDates(month: month, year: year)
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
        startTimePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        startTimePicker.addTarget(self, action: #selector(startTime(_:)), for: .valueChanged)
        
        endTimePicker = UIDatePicker()
        endTimePicker.datePickerMode = .time
        endTimePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        endTimePicker.addTarget(self, action: #selector(endTime(_:)), for: .valueChanged)
        
        scheduleButton.setup(title: "Schedule")
        
        jobSelection.text = self.jobTitle
        jobSelection.placeholder = "Job Title"
        jobSelection.isEnabled = false
        jobSelection.title = "Job Title"
        jobSelection.font = AppConstants.shared.textFieldFont
        jobSelection.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        jobSelection.lineColor = AppConstants.shared.primaryBlueColor
        jobSelection.selectedLineColor = AppConstants.shared.primaryBlueColor
        jobSelection.selectedTitleColor = AppConstants.shared.primaryBlueColor
        
        jobSelection.translatesAutoresizingMaskIntoConstraints = false
        
        candidateSelection.text = self.jobSeekerName
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
//        interviewStartTimeSelection.text = Date().toString(format: DateFormatType.custom("HH:mm"))
        
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
    }
    
    @objc func endTime(_ sender: UIDatePicker) {
        let date = sender.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let endTime = formatter.string(from: date)
        interviewEndTimeSelection.text = endTime
    }
    
    @objc func startTime(_ sender: UIDatePicker) {
        let date = sender.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
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
        
        // Loader
        hud.show(in: view)
        
        _ = APIClient.callAPI(request: APIClient.scheduleInterview(param: params), onSuccess: { (dictionary) in
            self.hud.dismiss(animated: true)
            self.toast.isShow("Interview scheduled successfully")
            self.navigationController?.popViewController(animated: true)
            print(dictionary)
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
            print(errorDictionary)
        }
    }
    
}

extension InterviewV2ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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

extension InterviewV2ViewController: UITextFieldDelegate {
    
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
                self.interviewStartTimeSelection.text = startTimePicker.date.toString(format: DateFormatType.custom("HH:mm"))
            }
        case interviewEndTimeSelection:
            
            if endTimePicker.date > startTimePicker.date {
                self.interviewEndTimeSelection.text = endTimePicker.date.toString(format: DateFormatType.custom("HH:mm"))
            }
            
        default:
            break
        }
    }
}

extension InterviewV2ViewController {
    
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
    
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func addMonth(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .month, value: n, to: self)!
    }
    func addDay(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .day, value: n, to: self)!
    }
    func addSec(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .second, value: n, to: self)!
    }
}
