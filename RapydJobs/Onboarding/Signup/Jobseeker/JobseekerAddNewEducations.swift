//
//  JobseekerAddNewEducations.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 24/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit
import SwiftVideoBackground
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON
import ObjectMapper

class JobseekerAddNewEducations: UIViewController, UITextFieldDelegate {
    
    private var toDatePicker: UIDatePicker!
    private var fromDatePicker: UIDatePicker!
    
    var educationModel: EducationModel?
    var educationIndex: Int?
    
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
        label.text = "Add New Education"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.textAlignment = .left
        label.font = AppConstants.shared.appDescFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private let educationTitleInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Education Title"
        input.title = "Education Title"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let institutionNameInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Institution Name"
        input.title = "Institution Name"
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
        input.placeholder = "Description"
        input.title = "Description"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let gradeInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Grade"
        input.title = "Grade"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let toInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "To"
        input.title = "To"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let fromInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "From"
        input.title = "From"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("ADD", for: .normal)
        button.titleLabel?.font = AppConstants.shared.buttonFont
        button.backgroundColor = AppConstants.shared.buttonGradientStart
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    private let dropdownToImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_dropdown")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let dropdownFromImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_dropdown")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
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
        
        toDatePicker = UIDatePicker()
        fromDatePicker = UIDatePicker()
        
        selectToDate()
        selectFromDate()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
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
        
        view.addSubview(mainStackView)
        mainStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 30).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        dropdownToImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        dropdownToImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        toInput.rightView = dropdownToImage
        toInput.rightViewMode = .always
        
        dropdownFromImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        dropdownFromImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        fromInput.rightView = dropdownFromImage
        fromInput.rightViewMode = .always
        
        mainStackView.addArrangedSubview(educationTitleInput)
        mainStackView.addArrangedSubview(institutionNameInput)
        mainStackView.addArrangedSubview(descriptionInput)
        mainStackView.addArrangedSubview(gradeInput)
        mainStackView.addArrangedSubview(fromInput)
        mainStackView.addArrangedSubview(toInput)        
        
        educationTitleInput.delegate = self
        institutionNameInput.delegate = self
        descriptionInput.delegate = self
        toInput.delegate = self
        
        view.addSubview(addButton)
        addButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20).isActive = true
        addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        if let eduModel = self.educationModel {
            educationTitleInput.text = eduModel.title ?? ""
            institutionNameInput.text = eduModel.instituteName ?? ""
            descriptionInput.text = eduModel.description ?? ""
            gradeInput.text = eduModel.grade ?? ""
            toInput.text = eduModel.to ?? ""
            fromInput.text = eduModel.from ?? ""
            self.addButton.setTitle("UPDATE", for: .normal)
        }
        
        if let index = self.educationIndex {
            let edu = educations[index]
            educationTitleInput.text = edu.educationTitle
            institutionNameInput.text = edu.institutionName
            descriptionInput.text = edu.description
            gradeInput.text = edu.grade
            toInput.text = edu.to
            fromInput.text = edu.from
            self.addButton.setTitle("UPDATE", for: .normal)
        }
        
        
    }
    
    private func selectToDate() {
        toDatePicker.datePickerMode = .date
        toDatePicker.maximumDate = Date()
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelToDatePicker))
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneToDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toInput.inputAccessoryView = toolbar
        toInput.inputView = toDatePicker
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == educationTitleInput {
            educationTitleInput.resignFirstResponder()
            institutionNameInput.becomeFirstResponder()
        } else if textField == institutionNameInput {
            institutionNameInput.resignFirstResponder()
            descriptionInput.becomeFirstResponder()
        } else if textField == descriptionInput {
            descriptionInput.resignFirstResponder()
            toInput.becomeFirstResponder()
        }
        return true
    }
    
    @objc func doneToDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dob = formatter.string(from: toDatePicker.date)
        toInput.text = dob
        
        self.view.endEditing(true)
    }
    
    @objc func cancelToDatePicker(){
        self.view.endEditing(true)
    }
    
    private func selectFromDate() {
        fromDatePicker.datePickerMode = .date
        fromDatePicker.maximumDate = Date()
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelFromDatePicker))
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneFromDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        fromInput.inputAccessoryView = toolbar
        fromInput.inputView = fromDatePicker
    }
    
    @objc func doneFromDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dob = formatter.string(from: fromDatePicker.date)
        fromInput.text = dob
        
        self.view.endEditing(true)
    }
    
    @objc func cancelFromDatePicker(){
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func goBack() {
        if educationTitleInput.text != "" {
            if institutionNameInput.text != "" {
                if descriptionInput.text != "" {
                    if toInput.text != "" {
                        if fromInput.text != "" {
                            
                            if EditProfileFlowManager.shared().isEditProfile {
                                
                                if let _ = self.educationModel {
                                    self.updateEducation()
                                } else {
                                    self.addEducation()
                                }
                                
                            } else {
                                let education = SignupEducation(educationTitle: educationTitleInput.text!, institutionName: institutionNameInput.text!, description: descriptionInput.text!, grade: gradeInput.text!, to: toInput.text!, from: fromInput.text!)
                                if let index = self.educationIndex {
                                    educations.remove(at: index)
                                }
                                educations.append(education)
                                navigationController?.popViewController(animated: true)
                            }
                            
                        } else {
                            AlertService.shared.alert(in: self, "Please select a start date for this education")
                        }
                    } else {
                        AlertService.shared.alert(in: self, "Please select end date of this education or select current month if still studying")
                    }
                } else {
                    AlertService.shared.alert(in: self, "Wrong Description")
                }
            } else {
                AlertService.shared.alert(in: self, "Wrong Institution Name")
            }
        } else {
            AlertService.shared.alert(in: self, "Wrong Education Title")
        }
    }
    
    func addEducation() {
        
        let param: [Parameters] = [
            [
                "title": self.educationTitleInput.text!,
                "institute_name": self.institutionNameInput.text!,
                "to": self.toInput.text!,
                "from": self.fromInput.text!,
                "description": self.descriptionInput.text!,
                "grade": self.gradeInput.text!
            ]
        ]
        print(param)
        let parameter = ["education": param]
        print(parameter)
        _ = APIClient.callAPI(request: .addEducation(param: parameter), onSuccess: { (dictionary) in
            print(dictionary)
            
            guard let educationArray = dictionary["data"] as? [[String:Any]] else {
                return
            }
            let educationModel: [EducationModel] = Mapper<EducationModel>().mapArray(JSONArray: educationArray)
            let user = AppContainer.shared.user.user
            if user?.education == nil {
               user?.education = educationModel
            } else {
                user?.education?.append(educationModel.first!)
            }
            
            AppContainer.shared.user.save(user: user!)
            self.navigationController?.popViewController(animated: true)
            
        }) { (errorDictionary, _) in
            print(errorDictionary)
        }
    }
    
    func updateEducation() {
        guard let id = self.educationModel?.id else {
            return
        }
        let param = [
            "title": self.educationTitleInput.text!,
            "institute_name": self.institutionNameInput.text!,
            "to": self.toInput.text!,
            "from": self.fromInput.text!,
            "description": self.descriptionInput.text!,
            "grade": self.gradeInput.text!
        ]
        print(param)
        _ = APIClient.callAPI(request: .updateEducation(param: param, id: id), onSuccess: { (dictionary) in
            print(dictionary)
            
            guard let eduModel: EducationModel = Mapper<EducationModel>().map(JSON: dictionary) else {
                return
            }
            print(eduModel.toJSON())
            let user = AppContainer.shared.user.user
            
            if let index = user?.education?.firstIndex(where: {$0.id == eduModel.id}) {
                user?.education?.remove(at: index)
            }
            
            user?.education?.append(eduModel)
            AppContainer.shared.user.save(user: user!)
            self.navigationController?.popViewController(animated: true)
            
        }) { (errorDictionary, _) in
            print(errorDictionary)
        }
        
    }
}
