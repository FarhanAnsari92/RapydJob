//
//  InterviewViewController.swift
//  RapydJobs
//
//  Created by Maroof Khan on 27/06/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import DropDown

class InterviewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout { //BaseViewController
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var jobSelection: SkyFloatingLabelTextField!
    @IBOutlet private weak var candidateSelection: SkyFloatingLabelTextField!
    @IBOutlet private weak var interviewStartTimeSelection: SkyFloatingLabelTextField!
    @IBOutlet private weak var interviewEndTimeSelection: SkyFloatingLabelTextField!
    
    @IBOutlet weak var monthSelection: BaseDropdownButton!
    @IBOutlet weak var scheduleButton: BaseButton!
    
    let dropDown = DropDown()
    var dates = [Int]()
    
    private let dropdownImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_dropdown")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var daySelector = DaySelector(month: .february, year: 2018)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        title = "Invite For Interview"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    private var startTimePicker: UIDatePicker!
    private var endTimePicker: UIDatePicker!
    
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
    }
    
    func getMonths() -> [String] {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        var stringDate = [String]()
        for i in 0..<12 {
            let dt = date.addMonth(n: i)
            let stringDt = formatter.string(from: dt)
            stringDate.append(stringDt)
        }
        return stringDate
        
    }
    
    //MARK: DropDown handler
    private func setup() {
        
        view.backgroundColor = Constants.Colors.primaryGreenColor
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        dropDown.anchorView = self.monthSelection
        dropDown.dataSource = self.getMonths()
        dropDown.bottomOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        DropDown.startListeningToKeyboard()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.monthSelection.titleLabel.text = item
            print(index)
            print(item)
            self.dates = self.startToEnd(date: index)
            print(self.dates.count)
            self.collectionView.reloadData()
        }
        
//        self.monthSelection.completion = {
//            self.dropDown.show()
//        }
        
        monthSelection.delegate = self
        
        dropdownImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        dropdownImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        startTimePicker = UIDatePicker()
        startTimePicker.datePickerMode = .time
        startTimePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        startTimePicker.addTarget(self, action: #selector(startTime(_:)), for: .valueChanged)
        
        endTimePicker = UIDatePicker()
        endTimePicker.datePickerMode = .time
        endTimePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        endTimePicker.addTarget(self, action: #selector(endTime(_:)), for: .valueChanged)
        
        scheduleButton.setup(title: "Schedule")
        
        jobSelection.text = "Android developer"
        jobSelection.placeholder = "Job Title"
        jobSelection.isEnabled = false
        jobSelection.title = "Job Title"
        jobSelection.font = AppConstants.shared.textFieldFont
        jobSelection.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        jobSelection.lineColor = AppConstants.shared.primaryBlueColor
        jobSelection.selectedLineColor = AppConstants.shared.primaryBlueColor
        jobSelection.selectedTitleColor = AppConstants.shared.primaryBlueColor
        
        jobSelection.translatesAutoresizingMaskIntoConstraints = false
        
        candidateSelection.text = "Syed Bilal Hussain"
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
    
    @IBAction func scheduleButtonTap(_ sender: BaseButton) {
        // API schedule here
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.dataSource = daySelector.datasource
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40.0, height: 60.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "day-selector", for: indexPath) as! DaySelectorCollectionViewCell
        cell.day.text = "\(self.dates[indexPath.row])"
        return cell
    }
    
    
}

extension InterviewViewController: BaseDropdownButtonDelegate {
    func didTap(_ button: BaseDropdownButton) {
        self.dropDown.show()
    }
}

extension InterviewViewController: SelectionDelegate {
    func showSelection(delegate: SelectionDelegate) {
        print(delegate)
    }
}

extension InterviewViewController: Initializable {
    static var storyboardName: String {
        return UIStoryboard.Name.inviteForInterviews.rawValue
    }
}

extension InterviewViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0 // accountTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "" // accountTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == startTimePicker {
            //self.interviewStartTimeSelection.text = pickerView.date
        } else if pickerView == endTimePicker {
            
        }
        //accountTypeInput.text = accountTypes[row]
    }
}

extension InterviewViewController {
    
    func currentDate() -> Int {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let stringDt = formatter.string(from: Date())
        return Int(stringDt)!
        
    }
    func getThisMonthEnd() -> Int {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: Date()) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        let date = Calendar.current.date(from: components as DateComponents)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let stringDt = formatter.string(from: date)
        return Int(stringDt)!
    }
    
    func getStartOf(month: Int) -> Int {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: Date()) as NSDateComponents
        components.month += month
        components.day = 1
        let date = Calendar.current.date(from: components as DateComponents)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let stringDt = formatter.string(from: date)
        return Int(stringDt)!
    }
    
    func getEndOf(month: Int) -> Int {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: Date()) as NSDateComponents
        components.month += month
        components.day = 1
        components.day -= 1
        let date = Calendar.current.date(from: components as DateComponents)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let stringDt = formatter.string(from: date)
        return Int(stringDt)!
    }
    
    func startToEnd(date: Int) -> [Int] {
        let start = getStartOf(month: date)
        let end = getEndOf(month: date + 1)
        print(start)
        print(end)
        var dateArr = [Int]()
        for i in start..<end {
            dateArr.append(i)
        }
        return dateArr
    }
    
}
//
//extension Date {
//    func addMonth(n: Int) -> Date {
//        let cal = NSCalendar.current
//        return cal.date(byAdding: .month, value: n, to: self)!
//    }
//    func addDay(n: Int) -> Date {
//        let cal = NSCalendar.current
//        return cal.date(byAdding: .day, value: n, to: self)!
//    }
//    func addSec(n: Int) -> Date {
//        let cal = NSCalendar.current
//        return cal.date(byAdding: .second, value: n, to: self)!
//    }
//    func startOfMonth() -> Date {
//        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
//    }
//    
//    func endOfMonth() -> Date {
//        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
//    }
//}


//extension InterviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.dates.count
//    }
//
//    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        //DaySelectorCollectionViewCell
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "day-selector", for: indexPath) as! DaySelectorCollectionViewCell
//        cell.day.text = "\(self.dates[indexPath.row])"
//        return cell
//
//    }
//
//
//}
