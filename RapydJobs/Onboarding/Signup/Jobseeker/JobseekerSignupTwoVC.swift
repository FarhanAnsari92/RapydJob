//
//  JobseekerSignupTwoVC.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 23/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit
import WARangeSlider
import SwiftVideoBackground
import SkyFloatingLabelTextField
import JGProgressHUD
import CoreLocation

var newRelatedFielfds = [String]()

class JobseekerSignupTwoVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    private let segueJobseekerMapVC = "JobseekerMapVC"
    private let segueJobseekerExperienceVC = "JobseekerExperienceVC"
    private var minSalVal = 0
    private var maxSalVal = 0
    
    private var pickerView: UIPickerView!
    private let pickerData = [ "10 mi", "15 mi", "20 mi","25 mi", "30 mi", "35 mi","40 mi", "45 mi", "50 mi"]
    
    var selectedAddress = ""
    var selectedWeeks: [[String:Any]]?
    var centerCoordinate: CLLocationCoordinate2D?
    
    private lazy var videoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.99, alpha: 0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Jobseeker!"
        label.textAlignment = .left
        label.font = AppConstants.shared.appTitleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Work Information"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.textAlignment = .left
        label.font = AppConstants.shared.appDescFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dropdownImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_dropdown")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let distanceDropdownImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_dropdown")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let locationImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "location-icon")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
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
    
    private let jobseekerAddressInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Address"
        input.title = "Jobseeker Address"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let shiftTimeInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Select Shift Time"
        input.title = "Shift Time"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let distanceInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Distance"
        input.title = "Distance"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let relatedFieldsInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Related Fields"
        input.title = "Related Fields"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
        sv.distribution = .fill
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
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("NEXT", for: .normal)
        button.titleLabel?.font = AppConstants.shared.buttonFont
        button.backgroundColor = AppConstants.shared.buttonGradientStart
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveToNext), for: .touchUpInside)
        return button
    }()
    
    private let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        return hud
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
        if EditProfileFlowManager.shared().isEditProfile {
            self.setupForEditProfile()
        }
        
    }
    
    func setupForEditProfile() {
        guard let user = AppContainer.shared.user.user else {
            return
        }
        self.jobseekerAddressInput.text = user.address?.address ?? ""
        
        
        if let relatedFields = user.relatedFields {
            
            var relatedFieldsSring: String = ""
            var relatedFieldArr: [String] = []
            for i in 0..<relatedFields.count {
                relatedFieldArr.append(relatedFields[i].relatedField ?? "")
                if i == 0{
                    relatedFieldsSring = relatedFields[i].relatedField ?? ""
                } else {
                    relatedFieldsSring = "\(relatedFieldsSring), \(relatedFields[i].relatedField ?? "")"
                }
            }
            
            self.relatedFieldsInput.text = relatedFieldsSring
        }
        
        self.minSalaryValue.text = user.jobSeeker?.minSalaryString ?? ""
        self.maxSalaryValue.text = user.jobSeeker?.maxSalaryString ?? ""
        
        self.rangeSlider.lowerValue = Double(Int(user.jobSeeker?.minSalaryString ?? "") ?? 0)
        self.rangeSlider.upperValue = Double(Int(user.jobSeeker?.maxSalaryString ?? "") ?? 0)
        
        let latitude = Double(user.address?.latitude ?? "") ?? 0.0
        let longitude = Double(user.address?.longitude ?? "") ?? 0.0
        
        self.centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        self.distanceInput.text = "\(user.address?.distance ?? "") mi"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        try? VideoBackground.shared.play(view: videoView, videoName: "Background", videoType: "mp4")
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //relatedFieldsInput.text = ""
    }

    private func setupViews() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if EditProfileFlowManager.shared().isEditProfile {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "EXPERIENCE >", style: .plain, target: self, action: #selector(experienceScreen))
        }
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        videoView = UIView(frame: CGRect(x: 0, y: -50, width: view.frame.width, height: view.frame.height + 100))
        view.addSubview(videoView)
        
        view.addSubview(backgroundView)
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        let topFrameHeight = UIApplication.shared.statusBarFrame.height + 80
        
        view.addSubview(titleStackView)
        titleStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: topFrameHeight).isActive = true
        titleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        titleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleMessageLabel)
        
        dropdownImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        dropdownImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        locationImage.heightAnchor.constraint(equalToConstant: 18).isActive = true
        locationImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        view.addSubview(mainStackView)
        mainStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 40).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(moveToMapVC(_:)))
        jobseekerAddressInput.addGestureRecognizer(tap)
        jobseekerAddressInput.inputView = UIView()
        jobseekerAddressInput.rightView = locationImage
        jobseekerAddressInput.rightViewMode = .always
        
        dropdownImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        dropdownImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        distanceDropdownImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        distanceDropdownImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        relatedFieldsInput.rightView = dropdownImage
        relatedFieldsInput.rightViewMode = .always
        relatedFieldsInput.addTarget(self, action: #selector(moveToRelatedFieldVC), for: .editingDidBegin)
        
        shiftTimeInput.rightViewMode = .always
        shiftTimeInput.addTarget(self, action: #selector(didTapShiftTime), for: .editingDidBegin)
        shiftTimeInput.inputView = UIView()
        
        distanceInput.rightView = distanceDropdownImage
        distanceInput.rightViewMode = .always
        distanceInput.inputView = self.pickerView
        
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
        
        mainStackView.addArrangedSubview(jobseekerAddressInput)
        mainStackView.addArrangedSubview(salaryMainStackView)
        mainStackView.addArrangedSubview(relatedFieldsInput)
        mainStackView.addArrangedSubview(shiftTimeInput)
        mainStackView.addArrangedSubview(distanceInput)
        
        jobseekerAddressInput.delegate = self
        relatedFieldsInput.delegate = self
        shiftTimeInput.delegate = self
        distanceInput.delegate = self
        
        view.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        minSalVal = Int(rangeSlider.lowerValue)
        maxSalVal = Int(rangeSlider.upperValue)
        
        minSalaryValue.text = "£ \(minSalVal)"
        maxSalaryValue.text = "£ \(maxSalVal)"
    }
    
    @objc func experienceScreen() {
        self.performSegue(withIdentifier: self.segueJobseekerExperienceVC, sender: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        distanceInput.text = pickerData[row]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == jobseekerAddressInput {
            jobseekerAddressInput.resignFirstResponder()
            //relatedFieldsInput.becomeFirstResponder()
        } else if textField == relatedFieldsInput || textField == shiftTimeInput {
            relatedFieldsInput.resignFirstResponder()
        } else if textField == distanceInput {
            jobseekerAddressInput.resignFirstResponder()
            relatedFieldsInput.resignFirstResponder()
            shiftTimeInput.resignFirstResponder()
            //distanceInput.becomeFirstResponder()
        }
        return true
    }
    
    @objc private func rangeSliderValueChanged(_ slider: RangeSlider) {
        
        minSalVal = Int(slider.lowerValue)
        maxSalVal = Int(slider.upperValue)
        
        minSalaryValue.text = "£ \(minSalVal)"
        maxSalaryValue.text = "£ \(maxSalVal)"
    }
    
    @objc private func didTapShiftTime() {
        view.endEditing(true)
        let sb = UIStoryboard(name: "JobseekerSignup", bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: "WeekViewController") as! WeekViewController
        
        vc.completion = { weeks in
            guard let wks = weeks, wks.count > 0 else {
                return
            }
            
            
            var str = ""
            for item in wks {
                str += "\(item["day"] as? String ?? ""),"
            }
            str.remove(at: str.index(before: str.endIndex))
            
            self.shiftTimeInput.text = str
            self.selectedWeeks = weeks
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func moveToRelatedFieldVC() {
        view.endEditing(true)
        let sb = UIStoryboard(name: "RelatedFields", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! RelatedFieldsViewController
        
        if self.relatedFieldsInput.text?.count ?? 0 > 0 {
            vc.selectedSectors = self.relatedFieldsInput.text?.components(separatedBy: ",")
        } else {
            vc.selectedSectors = [String]()
        }
        
        vc.selectedSectorCompletion = { relatedFieldArr in
            
            print(relatedFieldArr)
            self.relatedFieldsInput.text = relatedFieldArr.joined(separator: ",")
            print(relatedFieldArr)
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func moveToMapVC(_ tap: UITapGestureRecognizer) {
        view.endEditing(true)
        let sb = UIStoryboard(name: "JobseekerSignup", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "JobseekerMapVC") as! JobseekerMapVC
        vc.completion = { dictionary in
            self.centerCoordinate = dictionary["coordinate"] as? CLLocationCoordinate2D
            self.selectedAddress = dictionary["address"] as? String ?? ""
            self.jobseekerAddressInput.text = self.selectedAddress
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func moveToNext() {
        
        let distance = self.distanceInput.text?.split(separator: " ").first ?? ""
        print(distance)
        
        guard let latitude = self.centerCoordinate?.latitude,
            let longitude = self.centerCoordinate?.longitude else {
                AlertService.shared.alert(in: self, "Address is required.")
                return
        }
        
        guard let slctdWeeks = self.selectedWeeks, slctdWeeks.count > 0 else {
            AlertService.shared.alert(in: self, "Timesheet is required.")
            return
        }
        
        let lat = String(latitude)
        let lng = String(longitude)
    
        print(lat)
        
        let relatedFields = self.relatedFieldsInput.text?.split(separator: ",")
        
        var fields = [String]()
        for item in relatedFields! {
            fields.append(String(item))
        }
        
        print(fields)
        
        hud.show(in: view)
        JobseekerSignupAPIService.shared.updateAddress(schedule: slctdWeeks ,address: jobseekerAddressInput.text!, maxSalary: "\(maxSalVal)", minSalary: "\(minSalVal)", relatedFielfds: fields, distance: String(distance), lat: lat, lng: lng) { (error) in
            if let err = error {
                self.hud.dismiss(animated: true)
                print("Error : ", err)
            } else {
                self.hud.dismiss(animated: true)
                address = ""
                UserDefaults.standard.removeObject(forKey: "JOB_SECTORS")
                self.performSegue(withIdentifier: self.segueJobseekerExperienceVC, sender: nil)
            }
        }
    }
}
