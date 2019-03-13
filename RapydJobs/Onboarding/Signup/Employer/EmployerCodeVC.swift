//
//  EmployerCodeVC.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 17/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftVideoBackground
import JGProgressHUD

class EmployerCodeVC: UIViewController {

    private let segueEmployerSignupTwoVC = "EmployerSignupTwoVC"
    var completion: (() -> Void)?
    
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
        label.text = "Employer"
        label.textAlignment = .left
        label.font = AppConstants.shared.appTitleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Verify Via Email"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.textAlignment = .left
        label.font = AppConstants.shared.appDescFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let code1: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.text = "X"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.textAlignment = .center
        input.keyboardType = .numberPad
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let code2: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.text = "X"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.textAlignment = .center
        input.keyboardType = .numberPad
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let code3: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.text = "X"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.textAlignment = .center
        input.keyboardType = .numberPad
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let code4: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.text = "X"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.textAlignment = .center
        input.keyboardType = .numberPad
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let senAgainStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .equalCentering
        sv.spacing = 4
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let sendAgainMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't receive code?"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.textAlignment = .left
        label.font = AppConstants.shared.appDescFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sendAgainButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(AppConstants.shared.primaryBlueColor, for: .normal)
        button.setTitle("Send Again", for: .normal)
        button.titleLabel?.font = AppConstants.shared.buttonFont
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendCodeAgain), for: .touchUpInside)
        return button
    }()
    
//    private let editMobileNumberButton: UIButton = {
//        let button = UIButton()
//        button.setTitleColor(AppConstants.shared.primaryBlueColor, for: .normal)
//        button.setTitle("Edit Mobile Number", for: .normal)
//        button.titleLabel?.font = AppConstants.shared.buttonFont
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(sendCodeAgain), for: .touchUpInside)
//        return button
//    }()
    
    private let verifyButton: UIButton = {
        let button = UIButton()
        button.setTitle("VERIFY", for: .normal)
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
    
    private func setupViews() {
        
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_button"), style: .plain, target: self, action: #selector(self.backBtnTap))
        
        code1.addTarget(self, action: #selector(tfDidChange(tf:)), for: .editingChanged)
        code2.addTarget(self, action: #selector(tfDidChange(tf:)), for: .editingChanged)
        code3.addTarget(self, action: #selector(tfDidChange(tf:)), for: .editingChanged)
        code4.addTarget(self, action: #selector(tfDidChange(tf:)), for: .editingChanged)
        
        code1.clearsOnBeginEditing = true
        code2.clearsOnBeginEditing = true
        code3.clearsOnBeginEditing = true
        code4.clearsOnBeginEditing = true
        
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
        
        view.addSubview(codeStackView)
        codeStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 20).isActive = true
        codeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        codeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        codeStackView.addArrangedSubview(code1)
        codeStackView.addArrangedSubview(code2)
        codeStackView.addArrangedSubview(code3)
        codeStackView.addArrangedSubview(code4)
        
        view.addSubview(senAgainStackView)
        senAgainStackView.topAnchor.constraint(equalTo: codeStackView.bottomAnchor, constant: 20).isActive = true
        senAgainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        
        senAgainStackView.addArrangedSubview(sendAgainMessageLabel)
        senAgainStackView.addArrangedSubview(sendAgainButton)
        
//        view.addSubview(editMobileNumberButton)
//        editMobileNumberButton.topAnchor.constraint(equalTo: sendAgainButton.bottomAnchor, constant: 20).isActive = true
//        editMobileNumberButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        
        view.addSubview(verifyButton)
        verifyButton.topAnchor.constraint(equalTo: sendAgainButton.bottomAnchor, constant: 20).isActive = true
        verifyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        verifyButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        verifyButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func tfDidChange(tf: UITextField) {
        let text = tf.text
        if text?.utf16.count == 1 {
            switch tf {
            case code1:
                code2.becomeFirstResponder()
            case code2:
                code3.becomeFirstResponder()
            case code3:
                code4.becomeFirstResponder()
            case code4:
                code4.resignFirstResponder()
                moveToNext()
            default:
                break
            }
        }
    }
    
    @objc private func sendCodeAgain() {
        
        _ = APIClient.callAPI(request: APIClient.resendCode, onSuccess: { (dictionary) in
            print(dictionary)
            if let message = dictionary["message"] as? String {
                AlertService.shared.alert(in: self, message)
            }
        }) { (errorDictionary, _) in
            print(errorDictionary)
        }
    }
    
    @objc private func test_moveToNext() {
        self.completion?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func moveToNext() {
        
        if (code1.text != "" || code1.text != "X") && (code2.text != "" || code2.text != "X") && (code3.text != "" || code3.text != "X") && (code4.text != "" || code4.text != "X") {
            
            let code = "\(code1.text!)\(code2.text!)\(code3.text!)\(code4.text!)"
            
            hud.show(in: view)
            EmployerSignupAPIService.shared.verifyUser(in: self, code: code) { (error) in
                self.hud.dismiss(animated: true)
                if let err = error {
                    AlertService.shared.alert(in: self, "Wrong code, please insert write code to proceed further")
                } else {
                    AppContainer.shared.user.save(isLogin: true)
                    self.completion?()
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        } else {
            self.hud.dismiss(animated: true)
            
        }
    }
}
