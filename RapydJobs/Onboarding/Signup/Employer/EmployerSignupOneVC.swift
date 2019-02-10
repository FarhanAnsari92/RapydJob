//
//  EmployerSignupOneVC.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 16/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftVideoBackground
import JGProgressHUD

class EmployerSignupOneVC: UIViewController, UITextFieldDelegate {
    
    private let segueEmployerCodeVC = "EmployerCodeVC"
    
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
        label.text = "Employer!"
        label.textAlignment = .left
        label.font = AppConstants.shared.appTitleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Employer information"
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
        sv.spacing = 15
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let employerNameInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Organization Name"
        input.title = "Organization Name"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let employerRegNumInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Registration #"
        input.title = "Company Registration #"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let employerWebsiteInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Website"
        input.title = "Company Website"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.keyboardType = .URL
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let employerPhoneInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Mobile"
        input.title = "Company Mobile"
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        try? VideoBackground.shared.play(view: videoView, videoName: "Background", videoType: "mp4")
    }
    
    @objc func backBtnTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func navigateToAddressVC() {
        let sb = UIStoryboard(name: "EmployerSignup", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "EmployerSignupTwoVC") as! EmployerSignupTwoVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    private func setupViews() {
        if EditProfileFlowManager.shared().isEditProfile == true {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            
            navigationController?.navigationBar.tintColor = UIColor.black
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_button"), style: .plain, target: self, action: #selector(self.backBtnTap))
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ADDRESS>", style: .plain, target: self, action: #selector(navigateToAddressVC))
            
        } else {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            
            navigationController?.navigationBar.tintColor = UIColor.black            
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_button"), style: .plain, target: self, action: #selector(self.backBtnTap))
        }
        
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
        mainStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 40).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        mainStackView.addArrangedSubview(employerNameInput)
        mainStackView.addArrangedSubview(employerRegNumInput)
        mainStackView.addArrangedSubview(employerWebsiteInput)
        mainStackView.addArrangedSubview(employerPhoneInput)
        
        employerNameInput.delegate = self
        employerRegNumInput.delegate = self
        employerWebsiteInput.delegate = self
        employerPhoneInput.delegate = self
        
        view.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        if EditProfileFlowManager.shared().isEditProfile {
            guard let user = AppContainer.shared.user.user else {
                return
            }
            employerNameInput.text = user.organization?.organizationName ?? ""
            employerRegNumInput.text = user.organization?.registrationNumber ?? ""
            employerWebsiteInput.text = user.organization?.website ?? ""
            employerPhoneInput.text = user.organization?.contact ?? ""
            nextButton.setTitle("UPDATE", for: .normal)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == employerNameInput {
            employerNameInput.resignFirstResponder()
            employerRegNumInput.becomeFirstResponder()
        } else if textField == employerRegNumInput {
            employerRegNumInput.resignFirstResponder()
            employerWebsiteInput.becomeFirstResponder()
        } else if textField == employerWebsiteInput {
            employerWebsiteInput.resignFirstResponder()
            employerPhoneInput.becomeFirstResponder()
        } else if textField == employerPhoneInput {
            employerPhoneInput.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc private func moveToNext() {
        
        if employerNameInput.text != "" {
            if employerRegNumInput.text != "" {
                if employerWebsiteInput.text != "" {
                    if employerPhoneInput.text != "" {
                        hud.show(in: view)
                        UserDefaults.standard.set(employerPhoneInput.text!, forKey: "contactNumber")
                        UserDefaults.standard.synchronize()
                        
                        EmployerSignupAPIService.shared.updateEmployer(organizationName: employerNameInput.text!, website: employerWebsiteInput.text!, registrationNo: employerRegNumInput.text!, contactNo: employerPhoneInput.text!) { (error) in
                            if let err = error {
                                self.hud.dismiss(animated: true)
                                AlertService.shared.alert(in: self, err.localizedDescription)
                                print("🔥 Error : ", err)
                            } else {
                                self.hud.dismiss(animated: true)
                                if !EditProfileFlowManager.shared().isEditProfile {
                                    
                                    let sb = UIStoryboard(name: "EmployerSignup", bundle: nil)
                                    let vc = sb.instantiateViewController(withIdentifier: "EmployerCodeVC") as! EmployerCodeVC
                                    
                                    vc.completion = { () in
                                        
                                        let vc = sb.instantiateViewController(withIdentifier: "EmployerSignupTwoVC") as! EmployerSignupTwoVC
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    
                                    let nav = UINavigationController(rootViewController: vc)
                                    self.present(nav, animated: true, completion: nil)
                                    
                                }
                            }
                        }
                    } else {
                        AlertService.shared.alert(in: self, "Please insert Organization phone number")
                    }
                } else {
                    AlertService.shared.alert(in: self, "Please insert Organizations Website")
                }
            } else {
                AlertService.shared.alert(in: self, "Please insert Organization Registration Number")
            }
        } else {
            AlertService.shared.alert(in: self, "Please insert a Organization Name")
        }
    }
}
