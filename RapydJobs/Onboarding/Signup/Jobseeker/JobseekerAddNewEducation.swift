//
//  JobseekerAddNewEducation.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 24/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit
import SwiftVideoBackground
import SkyFloatingLabelTextField

class JobseekerAddNewEducations: UIViewController {
    
    private var toDatePicker: UIDatePicker!
    private var fromDatePicker: UIDatePicker!
    
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
        label.text = "Add New Experience"
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
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = AppConstants.shared.primaryGreenColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dropdownToImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "dropdown")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let dropdownFromImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "dropdown")
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
        
        try? VideoBackground.shared.play(view: view, videoName: "Background", videoType: "mp4")
    }

    private func setupViews() {
        
        toDatePicker = UIDatePicker()
        fromDatePicker = UIDatePicker()
        
        selectToDate()
        selectFromDate()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
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
        mainStackView.addArrangedSubview(toInput)
        mainStackView.addArrangedSubview(fromInput)
        
        view.addSubview(addButton)
        addButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20).isActive = true
        addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(bottomView)
        bottomView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
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
        toDatePicker.datePickerMode = .date
        toDatePicker.maximumDate = Date()
        
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
                            let education = Education(educationTitle: educationTitleInput.text!, institutionName: institutionNameInput.text!, description: descriptionInput.text!, to: toInput.text!, from: fromInput.text!)
                            educations.append(education)
                            navigationController?.popViewController(animated: true)
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
}
