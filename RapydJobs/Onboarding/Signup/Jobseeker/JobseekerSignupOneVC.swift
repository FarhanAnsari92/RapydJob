//
//  JobseekerSignupOneVC.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 23/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftVideoBackground
import JGProgressHUD

class JobseekerSignupOneVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    private let genders: [String] = [ "Male", "Female" ]
    private var pickerView: UIPickerView!
    private var datePicker: UIDatePicker!
    private let segueJobseekerCodeVC = "JobseekerCodeVC"
    
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
        label.text = "Jobseeker"
        label.textAlignment = .left
        label.font = AppConstants.shared.appTitleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Complete Your Profile"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.textAlignment = .left
        label.font = AppConstants.shared.appDescFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separator: UIView = {
        let vu = UIView()
        vu.backgroundColor = .gray
        vu.translatesAutoresizingMaskIntoConstraints = false
        return vu
    }()
    
    private let mainStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 15
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let fullNameInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Full Name"
        input.title = "Full Name"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let dobInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Date Of Birth"
        input.title = "Date Of Birth"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let descriptionInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Tagline"
        input.title = "Tagline"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let mobileNumberInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Mobile Number"
        input.title = "Mobile Number"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.keyboardType = .phonePad
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let genderInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Gender"
        input.title = "Select Your Gender"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
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

    private let dropdownImageDOB: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_dropdown")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let dropdownImageGender: UIImageView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        try? VideoBackground.shared.play(view: videoView, videoName: "Background", videoType: "mp4")
    }
    
    private func setupViews() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.backBtnTap))
        
        navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        datePicker = UIDatePicker()
        selectDOB()
        
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
        
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleMessageLabel)
        titleStackView.addArrangedSubview(separator)
        
        view.addSubview(mainStackView)
        mainStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 40).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        mainStackView.addArrangedSubview(fullNameInput)
        mainStackView.addArrangedSubview(dobInput)
        mainStackView.addArrangedSubview(descriptionInput)
        mainStackView.addArrangedSubview(mobileNumberInput)
        mainStackView.addArrangedSubview(genderInput)
        
        fullNameInput.delegate = self
        dobInput.delegate = self
        descriptionInput.delegate = self
        mobileNumberInput.delegate = self
        genderInput.delegate = self
        
        genderInput.text = "Male"
        
        dropdownImageDOB.heightAnchor.constraint(equalToConstant: 10).isActive = true
        dropdownImageDOB.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        dobInput.rightView = dropdownImageDOB
        dobInput.rightViewMode = .always
        
        dropdownImageGender.heightAnchor.constraint(equalToConstant: 10).isActive = true
        dropdownImageGender.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        genderInput.rightView = dropdownImageGender
        genderInput.rightViewMode = .always
        genderInput.inputView = pickerView
        
        view.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc func backBtnTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameInput {
            fullNameInput.resignFirstResponder()
            dobInput.becomeFirstResponder()
        } else if textField == dobInput {
            dobInput.resignFirstResponder()
            descriptionInput.becomeFirstResponder()
        } else if textField == descriptionInput {
            descriptionInput.resignFirstResponder()
            mobileNumberInput.becomeFirstResponder()
        } else if textField == mobileNumberInput {
            mobileNumberInput.resignFirstResponder()
            genderInput.delegate = self
        } else if textField == genderInput {
            genderInput.resignFirstResponder()
        }
        return true
    }
    
    private func selectDOB() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        dobInput.inputAccessoryView = toolbar
        dobInput.inputView = datePicker
    }
    
    var dateOfBirth = ""
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        
        let dob = formatter.string(from: datePicker.date)
        dobInput.text = dob
        
        formatter.dateFormat = "dd-MM-yyyy"
        
        dateOfBirth = formatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderInput.text = genders[row]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func test_moveToNext() {
        let sb = UIStoryboard(name: "JobseekerSignup", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "JobseekerCodeVC") as! JobseekerCodeVC
        
        vc.completion = { () in
            
            let vc = sb.instantiateViewController(withIdentifier: "JobseekerSignupTwoVC") as! JobseekerSignupTwoVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)}
    
    @objc private func moveToNext() {
        
        if fullNameInput.text != "" {
            if dobInput.text != "" {
                if descriptionInput.text != "" {
                    if mobileNumberInput.text != "" {
                        if genderInput.text != "" {
                            hud.show(in: view)
                            UserDefaults.standard.set(mobileNumberInput.text!, forKey: "contactNumber")
                            UserDefaults.standard.synchronize()
                            
                            JobseekerSignupAPIService.shared.updateJobseeker(fullName: fullNameInput.text!, dob: self.dateOfBirth, description: descriptionInput.text!, gender: genderInput.text!, contactNo: mobileNumberInput.text!) { (error) in
                                if let err = error {
                                    self.hud.dismiss(animated: true)
                                    print("Error : ", err)
                                } else {
                                    self.hud.dismiss(animated: true)
                                    
                                    let sb = UIStoryboard(name: "JobseekerSignup", bundle: nil)
                                    let vc = sb.instantiateViewController(withIdentifier: "JobseekerCodeVC") as! JobseekerCodeVC
                                    
                                    vc.completion = { () in
                                    
                                        let vc = sb.instantiateViewController(withIdentifier: "JobseekerSignupTwoVC") as! JobseekerSignupTwoVC
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    
                                    let nav = UINavigationController(rootViewController: vc)
                                    self.present(nav, animated: true, completion: nil)
                                    
                                    
                                }
                            }
                        } else {
                            AlertService.shared.alert(in: self, "Please select your gender")
                        }
                    } else {
                        AlertService.shared.alert(in: self, "Please insert your mobile number")
                    }
                } else {
                    AlertService.shared.alert(in: self, "Please insert a description")
                }
            } else {
                AlertService.shared.alert(in: self, "Please select your date of birth")
            }
        } else {
            AlertService.shared.alert(in: self, "Please insert your full name")
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }
}
