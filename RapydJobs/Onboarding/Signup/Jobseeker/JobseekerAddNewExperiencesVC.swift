//
//  JobseekerAddNewExperiencesVC.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 23/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit
import SwiftVideoBackground
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON
import ObjectMapper

class JobseekerAddNewExperiencesVC: UIViewController, UITextFieldDelegate {
    
    private var toDatePicker: UIDatePicker!
    private var fromDatePicker: UIDatePicker!
    
    var experienceModel: ExperienceModel?
    var experienceIndex: Int?
    
    var toast: JYToast!
    
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
    
    private let jobTitleInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Job Title"
        input.title = "Job Title"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let employerNameInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Employer Or Company Name"
        input.title = "Employer Or Company Name"
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
        
        self.toast = JYToast()
        
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
        
        mainStackView.addArrangedSubview(jobTitleInput)
        mainStackView.addArrangedSubview(employerNameInput)
        mainStackView.addArrangedSubview(descriptionInput)
        mainStackView.addArrangedSubview(toInput)
        mainStackView.addArrangedSubview(fromInput)
        
        jobTitleInput.delegate = self
        employerNameInput.delegate = self
        descriptionInput.delegate = self
        toInput.delegate = self
        
        view.addSubview(addButton)
        addButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20).isActive = true
        addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        if let expModel = self.experienceModel {
            self.jobTitleInput.text = expModel.title ?? ""
            self.employerNameInput.text = expModel.companyName ?? ""
            self.descriptionInput.text = expModel.description ?? ""
            self.toInput.text = expModel.to ?? ""
            self.fromInput.text = expModel.from ?? ""
            addButton.setTitle("UPDATE", for: .normal)
        }
        
        if let index = self.experienceIndex {
            let exp = experiences[index]
            self.jobTitleInput.text = exp.jobTitle
            self.employerNameInput.text = exp.employerName
            self.descriptionInput.text = exp.description
            self.toInput.text = exp.to
            self.fromInput.text = exp.from
            addButton.setTitle("UPDATE", for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == jobTitleInput {
            jobTitleInput.resignFirstResponder()
            employerNameInput.becomeFirstResponder()
        } else if textField == employerNameInput {
            employerNameInput.resignFirstResponder()
            descriptionInput.becomeFirstResponder()
        } else if textField == descriptionInput {
            descriptionInput.resignFirstResponder()
            toInput.becomeFirstResponder()
        } else if textField == toInput {
            toInput.resignFirstResponder()
        }
        return true
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
    
    func addExperience(experience: [String:Any]) {
        print(experience)
        var arr = [[String:Any]]()
        arr.append(experience)
        print(arr)
        
        var param = [Parameters]()
        
        
        for item in arr {
            
            let data: Parameters = [ "title" : item["title"] as? String ?? "",
                                     "company_name" : item["company_name"] as? String ?? "",
                                     "description" : item["description"] as? String ?? "",
                                     "to" : item["to"] as? String ?? "",
                                     "from" : item["from"] as? String ?? ""
            ]
            param.append(data)
        }
        
        
        
        let params = ["experience": param]
        print(params)
        
        /*
        let accessToken = AppContainer.shared.user.user?.accessToken ?? ""

        let url = URLConstants.shared.getEndPointURL("store-experience")
        print(url)
        
        let header = [  "Authorization" : "Bearer \(accessToken)",
            "Accept" : "application/json",
            "Content-Type" : "application/json" ]
        print(header)
        
//        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: header).response { (response) in
//            if let error = response.error {
//                print(error.localizedDescription)
//            } else {
//                if response.response?.statusCode == 200 {
//                    do {
//                        let json = try JSON(data: response.data!)
//                        print(json.dictionaryObject)
//                        print("Update Organiation Response : ", json)
//
//                    } catch let error as NSError {
//                        print(error.localizedDescription)
//                    }
//                } else {
//                    print("Something went wrong")
//                }
//
//            }
//        }
        */
        
        _ = APIClient.callAPI(request: APIClient.addExperience(param: params), onSuccess: { (dictionary) in

            print(dictionary)
            
            guard let expArray = dictionary["data"] as? [[String:Any]] else {
                return
            }
            self.toast.isShow("Experience added successfully")
            let expModel: [ExperienceModel] = Mapper<ExperienceModel>().mapArray(JSONArray: expArray)
            let user = AppContainer.shared.user.user
            if user?.experience == nil {
               user?.experience = expModel
            } else {
                user?.experience?.append(expModel.first!)
            }
            AppContainer.shared.user.save(user: user!)
            Helper.delay(0.3, closure: {
                self.navigationController?.popViewController(animated: true)
            })

        }) { (errorDictionary, _) in
            print(errorDictionary)
        }
//        //navigationController?.popViewController(animated: true)
    }
    
    func updateExperience(experience: [String:Any]) {
        guard let exp = self.experienceModel else {
            return
        }
        print(experience)
        _ = APIClient.callAPI(request: .updateExperience(param: experience, id: exp.id!), onSuccess: { (dictionary) in
            print(dictionary)
            guard let expModel: ExperienceModel = Mapper<ExperienceModel>().map(JSON: dictionary) else {
                return
            }
            self.toast.isShow("Experience updated successfully")
            let user = AppContainer.shared.user.user
            
            if let index = user?.experience?.firstIndex(where: {$0.id == expModel.id}) {
                user?.experience?.remove(at: index)
            }
            
            user?.experience?.append(expModel)
            AppContainer.shared.user.save(user: user!)
            Helper.delay(0.3, closure: {
                self.navigationController?.popViewController(animated: true)
            })
            
        }) { (errorDictionary, _) in
            print(errorDictionary)
        }
    }
    
    @objc private func goBack() {
        if jobTitleInput.text != "" {
            if employerNameInput.text != "" {
                if descriptionInput.text != "" {
                    if toInput.text != "" {
                        if fromInput.text != "" {
                            
                            if EditProfileFlowManager.shared().isEditProfile {
                                var params = [String:Any]()
                                params["title"] = jobTitleInput.text ?? ""
                                params["company_name"] = employerNameInput.text ?? ""
                                params["description"] = descriptionInput.text ?? ""
                                params["to"] = toInput.text ?? ""
                                params["from"] = fromInput.text ?? ""
                                
                                if let _ = self.experienceModel {
                                    self.updateExperience(experience: params)
                                } else {
                                    self.addExperience(experience: params)
                                }
                                
                            } else {
                                
                                let experience = SignupExperience(jobTitle: jobTitleInput.text!, employerName: employerNameInput.text!, description: descriptionInput.text!, to: toInput.text!, from: fromInput.text!)
                                
//                                if let index = self.experienceIndex {
//                                    experiences.remove(at: index)
//                                    experiences.append(experience)
//                                    navigationController?.popViewController(animated: true)
//                                } else {
//                                    experiences.append(experience)
//                                    navigationController?.popViewController(animated: true)
//                                }
                                
                                if let index = self.experienceIndex {
                                    experiences.remove(at: index)
                                }
                                experiences.append(experience)
                                navigationController?.popViewController(animated: true)
                                
                                
                            }
                            
                            
                            
                        } else {
                            AlertService.shared.alert(in: self, "Please select a start date of employement")
                        }
                    } else {
                        AlertService.shared.alert(in: self, "Please select end date of employement or select current month if still working")
                    }
                } else {
                    AlertService.shared.alert(in: self, "Wrong Description")
                }
            } else {
                AlertService.shared.alert(in: self, "Wrong Employer Name")
            }
        } else {
            AlertService.shared.alert(in: self, "Wrong Job Title")
        }
    }
}
