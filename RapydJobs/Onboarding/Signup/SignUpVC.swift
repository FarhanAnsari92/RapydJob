//
//  SignUpVC.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 16/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftVideoBackground
import JGProgressHUD
import LinkedinSwift
import Alamofire
import SwiftyJSON
import ObjectMapper

class SignUpVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    private let accountTypes: [String] = [ "Organization", "Jobseeker" ]
    private var pickerView: UIPickerView!
    var isSocialLogin: Bool = false
    var userName: String?
    var email: String?
    
    let linkedinHelper = LinkedinSwiftHelper(configuration:
        LinkedinSwiftConfiguration(
            clientId: Constants.linkedin.clientID,
            clientSecret: Constants.linkedin.clientSecret,
            state: "linkedin\(Int(NSDate().timeIntervalSince1970))",
            permissions: ["r_basicprofile", "r_emailaddress"],
            redirectUrl: "https://www.techadwiser.co.uk/auth/linkedin"
        )
    )
    
    private let scrollView: ScrollView = {
        let scroll = ScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        scroll.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        scroll.canCancelContentTouches = true
        scroll.delaysContentTouches = false
        return scroll
    }()
    
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
    
    private lazy var scrollingView: UIView = {
        let view = UIView()
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
        label.text = "Hello!"
        label.textAlignment = .left
        label.font = AppConstants.shared.appTitleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Create an account to continue"
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
    
    private let userNameInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Username"
        input.title = "Username"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
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
    
    private let passwordInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Password"
        input.title = "Password"
        input.font = AppConstants.shared.textFieldFont
        input.isSecureTextEntry = true
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let accountTypeInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Account"
        input.title = "Account Type"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("CREATE", for: .normal)
        button.titleLabel?.font = AppConstants.shared.buttonFont
        button.backgroundColor = AppConstants.shared.buttonGradientStart
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        return button
    }()
    
    private let loginStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .equalCentering
        sv.spacing = 4
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let loginMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.textAlignment = .left
        label.font = AppConstants.shared.appDescFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(AppConstants.shared.primaryBlueColor, for: .normal)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = AppConstants.shared.buttonFont
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginNow), for: .touchUpInside)
        return button
    }()
    
    private let linkedInButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "ic_linkedin"), for: .normal)
        button.setTitle("   SIGNUP USING LINKEDIN", for: .normal)
        button.titleLabel?.font = AppConstants.shared.buttonFont
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = AppConstants.shared.linkedIn
        button.addTarget(self, action: #selector(loginViaLinkedin), for: .touchUpInside)
        return button
    }()
    
    private let dropdownImage: UIImageView = {
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
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        accountTypeInput.text = "Organization"
        
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
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        scrollView.addSubview(scrollingView)
        scrollingView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        scrollingView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        scrollingView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        scrollingView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        scrollingView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        scrollingView.heightAnchor.constraint(greaterThanOrEqualToConstant: 680).isActive = true
        
        let topFrameHeight = UIApplication.shared.statusBarFrame.height + 60
        
        scrollingView.addSubview(titleStackView)
        titleStackView.topAnchor.constraint(equalTo: scrollingView.topAnchor, constant: topFrameHeight).isActive = true
        titleStackView.leadingAnchor.constraint(equalTo: scrollingView.leadingAnchor, constant: 30).isActive = true
        titleStackView.trailingAnchor.constraint(equalTo: scrollingView.trailingAnchor, constant: -30).isActive = true
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleMessageLabel)
        
        scrollingView.addSubview(mainStackView)
        mainStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 40).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: scrollingView.leadingAnchor, constant: 30).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: scrollingView.trailingAnchor, constant: -30).isActive = true
        
        mainStackView.addArrangedSubview(userNameInput)
        mainStackView.addArrangedSubview(emailInput)
        mainStackView.addArrangedSubview(passwordInput)
        mainStackView.addArrangedSubview(accountTypeInput)
        
        userNameInput.delegate = self
        emailInput.delegate = self
        passwordInput.delegate = self
        accountTypeInput.delegate = self
        
        dropdownImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        dropdownImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        accountTypeInput.rightView = dropdownImage
        accountTypeInput.rightViewMode = .always
        accountTypeInput.inputView = pickerView
        
        scrollingView.addSubview(createButton)
        createButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20).isActive = true
        createButton.leadingAnchor.constraint(equalTo: scrollingView.leadingAnchor, constant: 30).isActive = true
        createButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollingView.addSubview(loginStackView)
        loginStackView.bottomAnchor.constraint(equalTo: scrollingView.bottomAnchor, constant: -40).isActive = true
        loginStackView.leadingAnchor.constraint(equalTo: scrollingView.leadingAnchor, constant: 30).isActive = true
        
        loginStackView.addArrangedSubview(loginMessageLabel)
        loginStackView.addArrangedSubview(loginButton)
        
        scrollingView.addSubview(linkedInButton)
        linkedInButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        linkedInButton.bottomAnchor.constraint(equalTo: loginStackView.topAnchor, constant: -20).isActive = true
        linkedInButton.leadingAnchor.constraint(equalTo: scrollingView.leadingAnchor, constant: 30).isActive = true
        linkedInButton.trailingAnchor.constraint(equalTo: scrollingView.trailingAnchor, constant: -30).isActive = true
     
        if isSocialLogin {
            self.emailInput.text = email
            self.userNameInput.text = userName
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.isSocialLogin && textField == emailInput {
            return false
        }
        
        return true
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameInput {
            userNameInput.resignFirstResponder()
            emailInput.becomeFirstResponder()
        } else if textField == emailInput {
            emailInput.resignFirstResponder()
            passwordInput.becomeFirstResponder()
        } else if textField == passwordInput {
            passwordInput.resignFirstResponder()
            accountTypeInput.becomeFirstResponder()
        } else if textField == accountTypeInput {
            accountTypeInput.resignFirstResponder()
        }
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return accountTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return accountTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        accountTypeInput.text = accountTypes[row]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func loginNow() {
        dismiss(animated: true)
    }
    
    @objc private func loginViaLinkedin() {
        
        if !LinkedinSwiftHelper.isLinkedinAppInstalled() {
            AlertService.shared.alert(in: self, "You must install Linkedin App to login via Linkedin")
            return
        }
        
        hud.show(in: view)
        linkedinHelper.authorizeSuccess({ (lsToken) -> Void in
            //Login success lsToken
            print(lsToken)
            
            let url = "https://api.linkedin.com/v1/people/~:(id,first-name,last-name,headline,public-profile-url,picture-url,email-address,picture-urls::(original))?format=json";
            
            //Check if the user user is logged in and perform and action if they are.
            if self.linkedinHelper.lsAccessToken != nil {
                self.linkedinHelper.requestURL(url,
                                               requestType: LinkedinSwiftRequestGet,
                                               success: { (response) -> Void in
                                                
                                                print(response)
                                                //let res = response
                                                guard let dictionary = response.jsonObject as? [String:Any] else {
                                                    return
                                                }
                                                self.socialLogin(linkedinData: dictionary)
                                                
                                                
                                                //Request success response
                }) { (error) -> Void in
                    self.hud.dismiss(animated: true)
                    AlertService.shared.alert(in: self, error.localizedDescription)
                    //Encounter error
                }
            } else {
                self.hud.dismiss(animated: true);
            }
            
            
        }, error: { (error) -> Void in
            print(error)
            self.hud.dismiss(animated: true)
            AlertService.shared.alert(in: self, error.localizedDescription)
            //Encounter error: error.localizedDescription
        }, cancel: { () -> Void in
            self.hud.dismiss(animated: true)
            print("cancel")
            //User Cancelled!
        })
    }
    
    func socialLogin(linkedinData: [String:Any]) {

        var params = [String:Any]()
        params["provider"] = "linkedin"
        params["email"] = linkedinData["emailAddress"] as? String ?? ""
        params["fcm"] = (UIApplication.shared.delegate as! AppDelegate).apnsToken
        params["device_type"] = "ios"
        print(params)
        
        let url = URLConstants.shared.getEndPointURL("social-register")
        print("🌎 URL : ", url)
        let header = [ "Accept" : "application/json",
                       "Content-Type" : "application/json" ]
        print("🌎 Header : ", header)
        
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            
            self.hud.dismiss(animated: true)
            
            if let error = response.error {
                self.hud.dismiss(animated: true)
                AlertService.shared.alert(in: self, error.localizedDescription)
            } else {
                do {
                    print("Printing Response : ", response.response.unsafelyUnwrapped)
                    let _ = response.response!.statusCode
                    let json = try JSON(data: response.data!)
                    
                    guard let dictionary = json.dictionaryObject else {
                        AlertService.shared.alert(in: self, "Please try login later")
                        return
                    }
                    
                    let message = dictionary["message"] as? String ?? ""
                    if message == "user does not exist" {
                        self.isSocialLogin = true
                        self.emailInput.text = linkedinData["emailAddress"] as? String ?? ""
                        let firstName = linkedinData["firstName"] as? String ?? ""
                        let lastName = linkedinData["lastName"] as? String ?? ""
                        self.userNameInput.text = "\(firstName) \(lastName)"
                    } else {
                        
                        print(dictionary)
                        
                        let user: UserResponseModel = Mapper<UserResponseModel>().map(JSON: dictionary)!
                        print(user.toJSON())
                        AppContainer.shared.user.save(user: user)
                        
                        
                        let account_type = dictionary["account_type"] as? String ?? ""
                        let username = dictionary["username"] as? String ?? ""
                        let access_token = dictionary["access_token"] as? String ?? ""
                        let email = dictionary["email"] as? String ?? ""
                        let profile_image = dictionary["profile_image"] as? String ?? ""
                        let id = dictionary["id"] as? String ?? ""
                        
                        AppContainer.shared.user.save(email: email)
                        AppContainer.shared.user.save(token: access_token)
                        AppContainer.shared.user.save(userId: id)
                        AppContainer.shared.user.save(profileImage: profile_image)
                        AppContainer.shared.user.save(accountType: account_type)
                        AppContainer.shared.user.save(username: username)
                        
                        _ = LinkedinSwiftHelper.logout(self.linkedinHelper)
                        AppRouter.shared.proceed()
                    }
                } catch {
                    self.hud.dismiss(animated: true)
                    AlertService.shared.alert(in: self, error.localizedDescription)
                }
            }
        }
        
    }
    
    @objc private func createAccount() {
        
        
        if userNameInput.text != "" {
            if emailInput.text != "" {
                if passwordInput.text != "" {
                    if passwordInput.text!.count >= 6 {
                        hud.show(in: view)
                        if accountTypeInput.text == "Organization" {
                            InitialSignUpAPIService.shared.initialSignup(userNameInput.text!, emailInput.text!, passwordInput.text!, accountTypeInput.text!) { (message, error) in
                                
                                if let err = error {
                                    self.hud.dismiss(animated: true)
                                    print("Error : ", err)
                                    AlertService.shared.alert(in: self, err.localizedDescription)
                                } else if let msg = message {
                                    self.hud.dismiss(animated: true)
                                    AlertService.shared.alert(in: self, msg.capitalized)
                                } else {
                                    self.hud.dismiss(animated: true)
                                    let name = Storyboards.EmployerSignup.name()
                                    let sb = UIStoryboard(name: name, bundle: nil)
                                    let vc = sb.instantiateInitialViewController()!
                                    self.present(vc, animated: true)
                                }
                            }
                        } else {
                            InitialSignUpAPIService.shared.initialSignup(userNameInput.text!, emailInput.text!, passwordInput.text!, accountTypeInput.text!) { (message, error) in
                                if let err = error {
                                    self.hud.dismiss(animated: true)
                                    print("Error : ", err)
                                    AlertService.shared.alert(in: self, err.localizedDescription)
                                } else if let msg = message {
                                    self.hud.dismiss(animated: true)
                                    AlertService.shared.alert(in: self, msg.capitalized)
                                } else {
                                    self.hud.dismiss(animated: true)
                                    let name = Storyboards.JobseekerSignup.name()
                                    let sb = UIStoryboard(name: name, bundle: nil)
                                    let vc = sb.instantiateInitialViewController()!
                                    
                                    self.present(vc, animated: true)
                                }
                            }
                        }
                    } else {
                        AlertService.shared.alert(in: self, "Password should be minimum 6 digits long")
                    }
                } else {
                    AlertService.shared.alert(in: self, "Incorrect password, please insert a valid password")
                }
            } else {
                AlertService.shared.alert(in: self, "Incorrect email, please insert a valid email")
            }
        } else {
            AlertService.shared.alert(in: self, "Incorrect username, please insert a valid username")
        }
    }
}









