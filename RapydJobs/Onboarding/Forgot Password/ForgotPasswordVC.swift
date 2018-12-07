//
//  ForgotPasswordVC.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 16/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftVideoBackground
import JGProgressHUD

class ForgotPasswordVC: UIViewController {

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
        label.text = "Reset Password!"
        label.textAlignment = .left
        label.font = AppConstants.shared.appTitleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter email to reset password"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.textAlignment = .left
        label.font = AppConstants.shared.appDescFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Email"
        input.title = "Email Address"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        input.keyboardType = .emailAddress
        return input
    }()
    
    private let signinStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .equalCentering
        sv.spacing = 4
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let signinMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't want to reset?"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.textAlignment = .left
        label.font = AppConstants.shared.appDescFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signinNowButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(AppConstants.shared.primaryBlueColor, for: .normal)
        button.setTitle("Login Now", for: .normal)
        button.titleLabel?.font = AppConstants.shared.buttonFont
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("RESET", for: .normal)
        button.titleLabel?.font = AppConstants.shared.buttonFont
        button.backgroundColor = AppConstants.shared.buttonGradientStart
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(setNewPassword), for: .touchUpInside)
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

    private func setupViews() {
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        videoView = UIView(frame: CGRect(x: 0, y: -50, width: view.frame.width, height: view.frame.height + 100))
        view.addSubview(videoView)
                
        view.addSubview(backgroundView)
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        let topFrameHeight = UIApplication.shared.statusBarFrame.height + 60
        
        view.addSubview(titleStackView)
        titleStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: topFrameHeight).isActive = true
        titleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        titleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleMessageLabel)
        
        view.addSubview(emailInput)
        emailInput.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 40).isActive = true
        emailInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        emailInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        view.addSubview(signinStackView)
        signinStackView.topAnchor.constraint(equalTo: emailInput.bottomAnchor, constant: 20).isActive = true
        signinStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        
        signinStackView.addArrangedSubview(signinMessageLabel)
        signinStackView.addArrangedSubview(signinNowButton)
        
        view.addSubview(resetButton)
        resetButton.topAnchor.constraint(equalTo: signinStackView.bottomAnchor, constant: 20).isActive = true
        resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        resetButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func goBack() {
        dismiss(animated: true)
    }
    
    @objc private func setNewPassword() {
        
        if emailInput.text != "" {
            hud.show(in: view)
            ForgotPasswordAPIService.shared.resetPassword(emailInput.text!) { (message, error) in
                if let err = error {
                    print("Error : ", err)
                    self.hud.dismiss(animated: true)
                    AlertService.shared.alert(in: self, err.localizedDescription)
                } else if let msg = message {
                    self.hud.dismiss(animated: true)
                    AlertService.shared.alert(in: self, msg.capitalized)
                } else {
                    self.hud.dismiss(animated: true)
                    let vc = SetNewPasswordVC()
                    self.present(vc, animated: true)
                }
            }
        } else {
            AlertService.shared.alert(in: self, "Incorrect email address, please insert a valid email to reset password or consider signing up")
        }
    }
}









