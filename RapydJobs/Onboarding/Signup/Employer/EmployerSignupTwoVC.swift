//
//  EmployerSignupTwoVC.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 17/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftVideoBackground
import JGProgressHUD
import CoreLocation

var address = ""
var postalCode = ""

class EmployerSignupTwoVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let segueEmployerMapVC = "EmployerMapVC"
    private let segueEmployerUploadLogoVC = "EmployerUploadLogoVC"
    
    private var pickerView: UIPickerView!
    private let pickerData = [ "10 mi", "15 mi", "20 mi","25 mi", "30 mi", "35 mi","40 mi", "45 mi", "50 mi"]
    
    var selectedAddress = ""
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
        label.text = "Employer!"
        label.textAlignment = .left
        label.font = AppConstants.shared.appTitleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Organization address"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.textAlignment = .left
        label.font = AppConstants.shared.appDescFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "location-icon")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(moveToMapVC))
        iv.addGestureRecognizer(tap)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
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
    
    private let employerAddressInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Address"
        input.title = "Organization Address"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        //input.isEnabled = false
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let employerBuildingFloorInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Building Floor"
        input.title = "Building Floor (Optional)"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let employerPostalCodeInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Postal Code"
        input.title = "Postal Code"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let distanceDropdownImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_dropdown")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
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
        
        employerAddressInput.text = address
        employerPostalCodeInput.text = postalCode
    }
    
    @objc func navigateToAddressVC() {
        self.performSegue(withIdentifier: self.segueEmployerUploadLogoVC, sender: nil)
    }

    private func setupViews() {
        if EditProfileFlowManager.shared().isEditProfile == true {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "CHANGE LOGO>", style: .plain, target: self, action: #selector(navigateToAddressVC))
        } else {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        distanceDropdownImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        distanceDropdownImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        distanceInput.rightView = distanceDropdownImage
        distanceInput.rightViewMode = .always
        distanceInput.inputView = self.pickerView
        
        view.addSubview(mainStackView)
        mainStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 40).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        locationIcon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        locationIcon.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(moveToMapVC(_:)))
        locationIcon.addGestureRecognizer(tap)
        
        employerAddressInput.rightView = locationIcon
        employerAddressInput.rightViewMode = .always
        
        mainStackView.addArrangedSubview(employerAddressInput)
        mainStackView.addArrangedSubview(employerBuildingFloorInput)
        mainStackView.addArrangedSubview(employerPostalCodeInput)
        mainStackView.addArrangedSubview(distanceInput)
        
        employerAddressInput.delegate = self
        employerBuildingFloorInput.delegate = self
        employerPostalCodeInput.delegate = self
        
        view.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        if EditProfileFlowManager.shared().isEditProfile {
            guard let user = AppContainer.shared.user.user else {
                return
            }
            
            address = user.address?.address ?? ""
            employerAddressInput.text = user.address?.address ?? ""
            employerBuildingFloorInput.text = user.address?.buildingFloor ?? ""
            employerPostalCodeInput.text = user.address?.postalCode ?? ""
            
            let latitude = Double(user.address?.latitude ?? "") ?? 0.0
            let longitude = Double(user.address?.longitude ?? "") ?? 0.0
            
            self.centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            self.distanceInput.text = "\(user.address?.distance ?? "") mi"
            
            nextButton.setTitle("UPDATE", for: .normal)
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == employerAddressInput {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == employerAddressInput {
            employerAddressInput.resignFirstResponder()
            employerBuildingFloorInput.becomeFirstResponder()
        } else if textField == employerBuildingFloorInput {
            employerBuildingFloorInput.resignFirstResponder()
            employerPostalCodeInput.becomeFirstResponder()
        } else if textField == employerPostalCodeInput {
            employerPostalCodeInput.resignFirstResponder()
        }
        return true
    }
    
    @objc private func moveToMapVC(_ tap: UITapGestureRecognizer) {
        //sb EmployerSignup
        //id EmployerMapVC
        
        view.endEditing(true)
        let sb = UIStoryboard(name: "EmployerSignup", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "EmployerMapVC") as! EmployerMapVC
        
        vc.completion = { dictionary in
            self.centerCoordinate = dictionary["coordinate"] as? CLLocationCoordinate2D
            self.selectedAddress = dictionary["address"] as? String ?? ""            
            self.employerAddressInput.text = self.selectedAddress
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func moveToNext() {
        
        if self.distanceInput.text!.isEmpty {
            AlertService.shared.alert(in: self, "Please insert address to proceed")
            return
        }
        
        
        let distance = self.distanceInput.text?.split(separator: " ").first ?? ""
        print(distance)
        
        guard let latitude = self.centerCoordinate?.latitude,
            let longitude = self.centerCoordinate?.longitude else {
                AlertService.shared.alert(in: self, "Address is required.")
                return
        }
        
        let lat = String(latitude)
        let lng = String(longitude)
        
        print(lat)
        
        if employerAddressInput.text != "" {
            if employerBuildingFloorInput.text != "" {
                if employerPostalCodeInput.text != "" {
                    hud.show(in: view)
                    EmployerSignupAPIService.shared.updateAddress(address: employerAddressInput.text!, floor: employerBuildingFloorInput.text!, postCode: employerPostalCodeInput.text!, distance: String(distance), lat: lat, lng: lng) { (error) in
                        if let err = error {
                            self.hud.dismiss(animated: true)
                            print("Error : ", err)
                        } else {
                            self.hud.dismiss(animated: true)
                            if !EditProfileFlowManager.shared().isEditProfile {
                                self.performSegue(withIdentifier: self.segueEmployerUploadLogoVC, sender: nil)
                            }
                        }
                    }
                } else {
                    AlertService.shared.alert(in: self, "Please insert postal code to proceed")
                }
            } else {
                AlertService.shared.alert(in: self, "Please insert floor / building to proceed")
            }
        } else {
            AlertService.shared.alert(in: self, "Please insert address to proceed")
        }
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
}

