//
//  UpdateJobViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/3/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import WARangeSlider
import SkyFloatingLabelTextField
import JGProgressHUD
import ObjectMapper
import Alamofire

protocol UpdateJobViewControllerDelegate {
    func didUpdate(job: OrganizationJob)
}

class UpdateJobViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var organizationJob: OrganizationJob?
    var delegate: UpdateJobViewControllerDelegate?
    var selectedWeeks: [[String:Any]]?
    
    private let scrollView: ScrollView = {
        let scroll = ScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        scroll.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        scroll.canCancelContentTouches = true
        scroll.delaysContentTouches = false
        return scroll
    }()
    
    private lazy var scrollingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 20
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let jobSectorImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_dropdown")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let jobTimingImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_dropdown")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let jobTypeImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_dropdown")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let contractLengthImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_dropdown")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let jobTitleInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Job Title"
        input.title = "Job Title"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.tag = 0
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let jobSectorInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Job Sector"
        input.title = "Job Sector"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.tag = 1
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let jobDescriptionInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Job Description"
        input.title = "Job Description"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.tag = 2
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let sliderTitle: UILabel = {
        let label = UILabel()
        label.text = "SALARY RANGE"
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let salaryMainStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fill
        sv.alignment = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let salaryStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 0
        sv.distribution = .equalCentering
        sv.alignment = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let minSalaryStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 0
        sv.distribution = .fill
        sv.alignment = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let maxSalaryStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 0
        sv.distribution = .fill
        sv.alignment = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let minSalaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Min Salary: "
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont(name: "Poppins-Regular", size: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let minSalaryValue: UILabel = {
        let label = UILabel()
        label.text = "£ 15"
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let maxSalaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Max Salary: "
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.textAlignment = .right
        label.font = UIFont(name: "Poppins-Regular", size: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let maxSalaryValue: UILabel = {
        let label = UILabel()
        label.text = "£ 45"
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .right
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rangeSlider: RangeSlider = {
        let slider = RangeSlider()
        slider.trackTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        slider.thumbTintColor = AppConstants.shared.buttonGradientStart
        slider.trackHighlightTintColor = AppConstants.shared.buttonGradientStart
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.lowerValue = 15
        slider.upperValue = 50
        slider.isUserInteractionEnabled = true
        slider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let shiftTimingInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Shift Timing"
        input.title = "Shift Timing"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.tag = 3
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let jobTypeInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Job Type"
        input.title = "Job Type"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.tag = 4
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let lengthOfContractInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Length Of Contract"
        input.title = "Length Of Contract"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.tag = 5
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("SAVE", for: .normal)
        button.titleLabel?.font = AppConstants.shared.buttonFont
        button.backgroundColor = AppConstants.shared.buttonGradientStart
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submit), for: .touchUpInside)
        return button
    }()
    
    private let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        return hud
    }()
    
    private var minSalVal = 0
    private var maxSalVal = 0
//    private let shiftTiming = ["Morning", "Afternoon", "Evening"]
    private let jobType = ["Part Time", "Full Time", "Permanent"]
    private let lengthOfJob = ["1 week", "2 weeks", "3 weeks", "1 month", "2 months", "3 months"]
    private var shiftTimingPickerView: UIPickerView!
    private var jobTypePickerView: UIPickerView!
    private var lengthOfJobPickerView: UIPickerView!
    var toast: JYToast!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toast = JYToast()
        self.setupViews()
        guard let job = self.organizationJob else {
            return
        }
        print(job.toJSON())
        self.jobTitleInput.text = job.title
        self.jobDescriptionInput.text = job.description
        self.lengthOfContractInput.text = job.contractLength
        self.jobTypeInput.text = job.jobType
        
        let minSalary = job.minSalary
        let maxSalary = job.maxSalary
        rangeSlider.lowerValue = Double(minSalary ?? 0)
        rangeSlider.upperValue = Double(maxSalary ?? 0)
        
        minSalVal = job.minSalary
        maxSalVal = job.maxSalary
        
        minSalaryValue.text = "£ \(minSalVal)"
        maxSalaryValue.text = "£ \(maxSalVal)"
        
        var jobSelectedStr: String?
        for i in 0..<job.jobsRelatedField!.count {
            let relatedField = job.jobsRelatedField[i]
            let rawValue = relatedField["related_field"] as? String ?? ""
            if i == 0 {
                jobSelectedStr = rawValue
            } else {
                jobSelectedStr = "\(jobSelectedStr!),\(rawValue)"
            }
            
        }
        self.jobSectorInput.text = jobSelectedStr ?? ""
        
        var jobSelectedShiftTimingStr: String = ""
        
        guard job.dates.count > 0 else {
            return
        }
        self.selectedWeeks = job.dates.toJSON()
        for i in 0..<job.dates!.count {
            let date = job.dates[i]
            print(date.day)
            jobSelectedShiftTimingStr += "\(String(describing: date.day ?? "")),"

        }
        if jobSelectedShiftTimingStr.count > 0 {
            jobSelectedShiftTimingStr.remove(at: jobSelectedShiftTimingStr.index(before: jobSelectedShiftTimingStr.endIndex))
        }
        
        self.shiftTimingInput.text = jobSelectedShiftTimingStr
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for field in newRelatedFielfds {
            jobSectorInput.text?.append("\(field), ")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    private func setupViews() {
        
        title = "Edit Job"
        
        navigationItem.leftBarButtonItem = nil
        view.backgroundColor = Constants.Colors.primaryGreenColor
        
        shiftTimingPickerView = UIPickerView()
        shiftTimingPickerView.delegate = self
        shiftTimingPickerView.dataSource = self
        
        jobTypePickerView = UIPickerView()
        jobTypePickerView.delegate = self
        jobTypePickerView.dataSource = self
        
        lengthOfJobPickerView = UIPickerView()
        lengthOfJobPickerView.delegate = self
        lengthOfJobPickerView.dataSource = self
        
        let topFrameHeight = UIApplication.shared.statusBarFrame.height + 80
        
        jobSectorImage.heightAnchor.constraint(equalToConstant: 8).isActive = true
        jobSectorImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        jobTimingImage.heightAnchor.constraint(equalToConstant: 8).isActive = true
        jobTimingImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        jobTypeImage.heightAnchor.constraint(equalToConstant: 8).isActive = true
        jobTypeImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        contractLengthImage.heightAnchor.constraint(equalToConstant: 8).isActive = true
        contractLengthImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        scrollView.addSubview(scrollingView)
        scrollingView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        scrollingView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        scrollingView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        scrollingView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        scrollingView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        scrollingView.heightAnchor.constraint(greaterThanOrEqualToConstant: 680).isActive = true
        
        scrollingView.addSubview(mainStackView)
        mainStackView.topAnchor.constraint(equalTo: scrollingView.topAnchor, constant: topFrameHeight).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: scrollingView.leadingAnchor, constant: 25).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: scrollingView.trailingAnchor, constant: -25).isActive = true
        
        rangeSlider.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        minSalaryStackView.addArrangedSubview(minSalaryLabel)
        minSalaryStackView.addArrangedSubview(minSalaryValue)
        
        maxSalaryStackView.addArrangedSubview(maxSalaryLabel)
        maxSalaryStackView.addArrangedSubview(maxSalaryValue)
        
        salaryStackView.addArrangedSubview(minSalaryStackView)
        salaryStackView.addArrangedSubview(maxSalaryStackView)
        
        salaryMainStackView.addArrangedSubview(sliderTitle)
        salaryMainStackView.addArrangedSubview(rangeSlider)
        salaryMainStackView.addArrangedSubview(salaryStackView)
        
        mainStackView.addArrangedSubview(jobTitleInput)
        mainStackView.addArrangedSubview(jobSectorInput)
        mainStackView.addArrangedSubview(jobDescriptionInput)
        mainStackView.addArrangedSubview(salaryMainStackView)
        mainStackView.addArrangedSubview(shiftTimingInput)
        mainStackView.addArrangedSubview(jobTypeInput)
        mainStackView.addArrangedSubview(lengthOfContractInput)
        
        jobTypeInput.delegate = self
        jobTitleInput.delegate = self
        jobSectorInput.delegate = self
        jobDescriptionInput.delegate = self
        shiftTimingInput.delegate = self
        lengthOfContractInput.delegate = self
        
        jobSectorInput.rightView = jobSectorImage
        jobSectorInput.rightViewMode = .always
        jobSectorInput.keyboardAppearance = .alert
        jobSectorInput.addTarget(self, action: #selector(moveToRelatedFieldVC(_:)), for: .editingDidBegin)
        
        shiftTimingInput.rightView = jobTimingImage
        shiftTimingInput.rightViewMode = .always
        //shiftTimingInput.inputView = shiftTimingPickerView
        shiftTimingInput.addTarget(self, action: #selector(didTapShiftTime), for: .editingDidBegin)
        
        jobTypeInput.rightView = jobTypeImage
        jobTypeInput.rightViewMode = .always
        jobTypeInput.inputView = jobTypePickerView
        
        lengthOfContractInput.rightView = contractLengthImage
        lengthOfContractInput.rightViewMode = .always
        lengthOfContractInput.inputView = lengthOfJobPickerView
        
        scrollingView.addSubview(createButton)
        createButton.leadingAnchor.constraint(equalTo: scrollingView.leadingAnchor, constant: 30).isActive = true
        createButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20).isActive = true
        createButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        minSalVal = Int(rangeSlider.lowerValue)
        maxSalVal = Int(rangeSlider.upperValue)
        
        shiftTimingInput.text = "Morning"
        jobTypeInput.text = organizationJob?.jobType
        lengthOfContractInput.text = organizationJob?.contractLength
        
        minSalaryValue.text = "£ \(minSalVal)"
        maxSalaryValue.text = "£ \(maxSalVal)"
    }
    
    @objc private func didTapShiftTime() {
        view.endEditing(true)
        let sb = UIStoryboard(name: "JobseekerSignup", bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: "WeekViewController") as! WeekViewController
        if let slctdWks = self.selectedWeeks {
            vc.selectedWeek = slctdWks
        }
        
        vc.completion = { weeks in
            guard let wks = weeks, wks.count > 0 else {
                return
            }
            
            
            var str = ""
            for item in wks {
                str += "\(item["day"] as? String ?? ""),"
            }
            str.remove(at: str.index(before: str.endIndex))
            
            self.shiftTimingInput.text = str
            self.selectedWeeks = weeks
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == jobTitleInput {
            jobTitleInput.resignFirstResponder()
            jobSectorInput.becomeFirstResponder()
        } else if textField == jobSectorInput {
            jobSectorInput.resignFirstResponder()
            jobDescriptionInput.becomeFirstResponder()
        } else if textField == jobDescriptionInput {
            jobDescriptionInput.resignFirstResponder()
            shiftTimingInput.becomeFirstResponder()
        } else if textField == shiftTimingInput {
            shiftTimingInput.resignFirstResponder()
            jobTypeInput.becomeFirstResponder()
        } else if textField == jobTypeInput {
            jobTypeInput.resignFirstResponder()
            lengthOfContractInput.becomeFirstResponder()
        } else if textField == lengthOfContractInput {
            lengthOfContractInput.resignFirstResponder()
        }
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case lengthOfJobPickerView:
            return lengthOfJob.count
//        case shiftTimingPickerView:
//            return shiftTiming.count
        default:
            return jobType.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case lengthOfJobPickerView:
            return lengthOfJob[row]
//        case shiftTimingPickerView:
//            return shiftTiming[row]
        default:
            return jobType[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case lengthOfJobPickerView:
            lengthOfContractInput.text = lengthOfJob[row]
//        case shiftTimingPickerView:
//            shiftTimingInput.text = shiftTiming[row]
        default:
            jobTypeInput.text = jobType[row]
        }
    }
    
    @objc private func rangeSliderValueChanged(_ slider: RangeSlider) {
        
        minSalVal = Int(slider.lowerValue)
        maxSalVal = Int(slider.upperValue)
        
        minSalaryValue.text = "£ \(minSalVal)"
        maxSalaryValue.text = "£ \(maxSalVal)"
    }
    
    @objc private func moveToRelatedFieldVC(_ textField: UITextField) {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        let sb = UIStoryboard(name: "RelatedFields", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "UpdateRelatedFieldsViewControllerID") as! UpdateRelatedFieldsViewController
        
        if self.jobSectorInput.text?.count ?? 0 > 0 {
            vc.selectedSectors = self.jobSectorInput.text?.components(separatedBy: ",")
        } else {
            vc.selectedSectors = [String]()
        }
        
        vc.selectedSectorCompletion = { selectedSectos in
            print(selectedSectos)
            self.jobSectorInput.text = selectedSectos.joined(separator: ",")
            print(selectedSectos)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func jobPostFailed(error: Error) {
        AlertService.shared.alert(in: self, "Job creation failed,\n\(error.localizedDescription)")
    }
    
    private func jobPosted() {
        AlertService.shared.alert(in: self, "Job created successfully")
        AppRouter.shared.proceed()
        newRelatedFielfds.removeAll()
        UserDefaults.standard.removeObject(forKey: "JOB_SECTORS")
    }
    
    @objc func submit() {
        
        guard let slctdWeeks = self.selectedWeeks, slctdWeeks.count > 0 else {
            AlertService.shared.alert(in: self, "Timesheet is required.")
            return
        }
        
        if jobTitleInput.text != "" {
            if jobSectorInput.text != "" {
                if jobDescriptionInput.text != "" {
                    if shiftTimingInput.text != "" {
                        if jobTypeInput.text != "" {
                            if lengthOfContractInput.text != "" {
                                
                                let jobId = organizationJob?.id
                                print(jobId)
                                let relatedFields = self.jobSectorInput.text?.split(separator: ",")
                                
                                var fields = [String]()
                                for item in relatedFields! {
                                    fields.append(String(item))
                                }
                                
                                print(fields)
                                
//                                let params: Parameters = [ "title" : jobTitleInput.text!,
//                                                             "description" : jobDescriptionInput.text!,
//                                                             "min_salary" : minSalVal,
//                                                             "max_salary" : maxSalVal,
//                                                             "job_type" : jobTypeInput.text!.lowercased(),
//                                                             "contract_length"    : lengthOfContractInput.text!.lowercased(),
//                                                             "related_fields"     : fields,
//                                                             "dates"              : slctdWeeks
//                                ] as [String:Any]
                                
                                var params = [String:Any]()
                                params["title"] = jobTitleInput.text!
                                params["description"] = jobDescriptionInput.text!
                                params["min_salary"] = minSalVal
                                params["max_salary"] = maxSalVal
                                params["job_type"] = jobTypeInput.text!.lowercased()
                                params["contract_length"] = lengthOfContractInput.text!.lowercased()
                                params["related_fields"] = fields
                                params["dates"] = slctdWeeks
                                
                                print(params)
                                let asda = params
                                
                                hud.show(in: view)
                                _ = APIClient.callAPI(request: .updateJob(id: jobId!, param: params), onSuccess: { (dictionary) in
                                    self.hud.dismiss(animated: true)
                                    print(dictionary)
                                    
                                    if let job = Mapper<OrganizationJob>().map(JSON: dictionary) {
                                        self.delegate?.didUpdate(job: job)
                                    }
                                    self.navigationController?.popViewController(animated: true)
                                    
                                }) { (errorDictionary, _) in
                                    self.hud.dismiss(animated: true)
                                    print(errorDictionary)
                                    if let msg = errorDictionary["message"] {
                                        self.toast.isShow(msg as! String)
                                    } else {
                                        self.toast.isShow("Somethingwent wrong")
                                    }
                                    
                                }
                                
                            } else {
                                AlertService.shared.alert(in: self, "Please select job length to proceed")
                            }
                        } else {
                            AlertService.shared.alert(in: self, "Please select job type")
                        }
                    } else {
                        AlertService.shared.alert(in: self, "Please add shift timing for the job")
                    }
                } else {
                    AlertService.shared.alert(in: self, "Please add a short description for the job")
                }
            } else {
                AlertService.shared.alert(in: self, "Please select atleast 1 job sector")
            }
        } else {
            AlertService.shared.alert(in: self, "Please insert job title")
        }
    }
}

