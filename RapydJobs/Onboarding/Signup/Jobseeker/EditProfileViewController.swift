//
//  EditProfileViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/20/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftVideoBackground
import JGProgressHUD
import ObjectMapper

class EditProfileViewController: UIViewController,  UITextFieldDelegate {
    
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
        label.text = "Update Your Profile"
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
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("DONE", for: .normal)
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
    
    var toast: JYToast!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toast = JYToast()
        self.setupViews()
        self.setupData()
    }
    
    func setupData() {
        guard let user = AppContainer.shared.user.user else {
            return
        }
        self.fullNameInput.text = user.jobSeeker?.fullName ?? ""
        self.mobileNumberInput.text = user.jobSeeker?.contact ?? ""
        self.descriptionInput.text = user.jobSeeker?.description ?? ""
    }
    
    @objc func backBtnTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        try? VideoBackground.shared.play(view: videoView, videoName: "Background", videoType: "mp4")
    }
    
    private func setupViews() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backArrow"), style: .plain, target: self, action: #selector(self.backBtnTap))
        
        navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ADDRESS>", style: .plain, target: self, action: #selector(navigateToAddressVC))
        
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
        mainStackView.addArrangedSubview(descriptionInput)
        mainStackView.addArrangedSubview(mobileNumberInput)
        
        fullNameInput.delegate = self
        descriptionInput.delegate = self
        mobileNumberInput.delegate = self
        
        view.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc func navigateToAddressVC() {
        EditProfileFlowManager.shared().isEditProfile = true
        // class JobseekerSignupTwoVC
        self.performSegue(withIdentifier: "segueAddressVC", sender: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameInput {
            fullNameInput.resignFirstResponder()
            descriptionInput.becomeFirstResponder()
        } else if textField == descriptionInput {
            descriptionInput.resignFirstResponder()
            mobileNumberInput.becomeFirstResponder()
        } else if textField == mobileNumberInput {
            mobileNumberInput.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func moveToNext() {
        EditProfileFlowManager.shared().isEditProfile = true
//        self.performSegue(withIdentifier: "segueAddressVC", sender: nil)
//        return
        
        let param = [
            "fullname": self.fullNameInput.text ?? "",
            "description": self.descriptionInput.text ?? "",
            "contact": self.mobileNumberInput.text ?? ""
        ]
        
        let finalParam = ["jobseeker": param]
        _ = APIClient.callAPI(request: .updateJobSeeker(param: finalParam), onSuccess: { (dictionary) in
            
            self.toast.isShow("Profile Updated successfully")
            
            let user = AppContainer.shared.user.user
            if let jobseekerDic = dictionary["jobseeker"] as? [String:Any] {
                let jobseekerModel: JobSeekerModel = Mapper<JobSeekerModel>().map(JSON: jobseekerDic)!
                //user?.address = addressModel
                user?.jobSeeker = jobseekerModel
                AppContainer.shared.user.save(user: user!)
            }
            
            print(dictionary)
        }) { (errorDictionary, _) in
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
            print(errorDictionary)
        }
        
//        return
//
//        if fullNameInput.text != "" {
//
//            if descriptionInput.text != "" {
//                if mobileNumberInput.text != "" {
//
//                    hud.show(in: view)
//                    UserDefaults.standard.set(mobileNumberInput.text!, forKey: "contactNumber")
//                    UserDefaults.standard.synchronize()
//
//
//
//
//                    JobseekerSignupAPIService.shared.updateJobseeker(fullName: fullNameInput.text!, dob: "", description: descriptionInput.text!, gender: "", contactNo: mobileNumberInput.text!) { (error) in
//                        if let err = error {
//                            self.hud.dismiss(animated: true)
//                            print("Error : ", err)
//                        } else {
//                            self.hud.dismiss(animated: true)
//                            //self.performSegue(withIdentifier: self.segueJobseekerCodeVC, sender: nil)
//                            self.performSegue(withIdentifier: "segueAddressVC", sender: nil)
//                        }
//                    }
//
//                } else {
//                    AlertService.shared.alert(in: self, "Please insert your mobile number")
//                }
//            } else {
//                AlertService.shared.alert(in: self, "Please insert a description")
//            }
//
//        } else {
//            AlertService.shared.alert(in: self, "Please insert your full name")
//        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }
}
