//
//  LoginVC.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 16/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftVideoBackground
import JGProgressHUD
import ObjectMapper
import LinkedinSwift
import Alamofire
import SwiftyJSON
import ObjectMapper
import IOSLinkedInAPIFix


class LoginVC: UIViewController {
    
    let linkedinHelper = LinkedinSwiftHelper(configuration:
        LinkedinSwiftConfiguration(
            clientId: Constants.linkedin.clientID,
            clientSecret: Constants.linkedin.clientSecret,
            state: "linkedin\(Int(NSDate().timeIntervalSince1970))",
            permissions: ["r_basicprofile", "r_emailaddress"],
            redirectUrl: "https://www.techadwiser.co.uk/auth/linkedin"
        )
    )
    
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
        label.text = "Welcome!"
        label.textAlignment = .left
        label.font = AppConstants.shared.appTitleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Login to existing account"
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
        input.placeholder = "Email"
        input.title = "Email"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
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
    
    private let forgotPasswordStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .equalCentering
        sv.spacing = 4
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot password?"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.textAlignment = .left 
        label.font = AppConstants.shared.appDescFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let resetNowButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(AppConstants.shared.primaryBlueColor, for: .normal)
        button.setTitle("Reset Now", for: .normal)
        button.titleLabel?.font = AppConstants.shared.buttonFont
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        return button
    }()
    
    private let loginButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("LOG IN", for: .normal)
        button.titleLabel?.font = AppConstants.shared.buttonFont
        button.backgroundColor = AppConstants.shared.buttonGradientStart
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    
    private let signupStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .equalCentering
        sv.spacing = 4
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let signupMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.textAlignment = .left
        label.font = AppConstants.shared.appDescFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(AppConstants.shared.primaryBlueColor, for: .normal)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = AppConstants.shared.buttonFont
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signupNow), for: .touchUpInside)
        return button
    }()
  
    private let linkedInButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("LOGIN USING LINKEDIN", for: .normal)
        button.titleLabel?.font = AppConstants.shared.buttonFont
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(loginViaLinkedin), for: .touchUpInside)
        button.backgroundColor = AppConstants.shared.linkedIn
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
        
        view.addSubview(mainStackView)
        mainStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 40).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        mainStackView.addArrangedSubview(userNameInput)
        mainStackView.addArrangedSubview(passwordInput)
        
        view.addSubview(forgotPasswordStackView)
        forgotPasswordStackView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20).isActive = true
        forgotPasswordStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        
        forgotPasswordStackView.addArrangedSubview(forgotPasswordLabel)
        forgotPasswordStackView.addArrangedSubview(resetNowButton)
        
        view.addSubview(loginButton)
        loginButton.topAnchor.constraint(equalTo: forgotPasswordStackView.bottomAnchor, constant: 20).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(signupStackView)
        signupStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        signupStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        
        signupStackView.addArrangedSubview(signupMessageLabel)
        signupStackView.addArrangedSubview(signupButton)
        
        view.addSubview(linkedInButton)
        linkedInButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        linkedInButton.bottomAnchor.constraint(equalTo: signupStackView.topAnchor, constant: -20).isActive = true
        linkedInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        linkedInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        linkedInButton.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func resetPassword() {
        let vc = ForgotPasswordVC()
        present(vc, animated: true)
    }
    
    @objc private func signupNow() {
        let vc = SignUpVC()
        present(vc, animated: true)
    }
    
    @objc private func loginViaLinkedin() {
//        let accessTkn = LISDKAccessToken()
//        let token = UserDefaults.standard.string(forKey: accessTkn.accessTokenValue)
//        if (token?.count)! > 0 {
//
//        } else {
//
//        }
        
        let permissions = [LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION]
        
        LISDKSessionManager.createSession(withAuth: permissions, state: nil/*Constants.linkedin.state*/, showGoToAppStoreDialog: true, successBlock: { (returnState) in
            
            if LISDKSessionManager.hasValidSession() {
            
                let urlString = String(format: "%@/people/~:(id,first-name,last-name,maiden-name,email-address)", LINKEDIN_API_URL)
                LISDKAPIHelper.sharedInstance()?.getRequest(urlString, success: { (response) in
                    print(response)
                    print(response)
                }, error: { (error) in
                    print(error?.localizedDescription)
                })
                
            }
            
            
        }) { (error) in
            print(error?.localizedDescription)
        }
        
    }
    
    @objc private func oldloginViaLinkedin() {
        
        
        
        if !LinkedinSwiftHelper.isLinkedinAppInstalled() {
            AlertService.shared.alert(in: self, "You must install Linkedin App to login via Linkedin")
            return
        }
        
        hud.show(in: view)
        
        linkedinHelper.authorizeSuccess({ (lsToken) -> Void in
            //Login success lsToken
            print(lsToken)
            
            let url = "https://www.linkedin.com/oauth/v2/authorization" // "https://api.linkedin.com/v1/people/~:(id,first-name,last-name,headline,public-profile-url,picture-url,email-address,picture-urls::(original))?format=json";
            
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
                
            }
            
            
        }, error: { (error) -> Void in
            print(error)
            self.hud.dismiss(animated: true)
            AlertService.shared.alert(in: self, error.localizedDescription)
            //Encounter error: error.localizedDescription
        }, cancel: { () -> Void in
            print("cancel")
            self.hud.dismiss(animated: true)
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
                        
                        let firstName = linkedinData["firstName"] as? String ?? ""
                        let lastName = linkedinData["lastName"] as? String ?? ""
                        self.userNameInput.text = "\(firstName) \(lastName)"
                        
                        
                        let vc = SignUpVC()
//                        vc.isSocialLogin = true
//                        vc.userName = "\(firstName) \(lastName)"
//                        vc.email = linkedinData["emailAddress"] as? String ?? ""
                        self.present(vc, animated: true)
                        
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
    
    @objc private func login() {
        self.view.endEditing(true)
        if userNameInput.text != "" {
            if passwordInput.text != "" {
                hud.show(in: view)
                
                let params = [ "username" : userNameInput.text!,
                               "password" : passwordInput.text!,
                               "grant_type" : "password",
                               "client_id" : "2",
                               "client_secret" : "\(AppConstants.shared.clientSecret)",
                               "device_type"    : "ios",
                    "fcm": (UIApplication.shared.delegate as! AppDelegate).apnsToken]
                
                _ = APIClient.callAPI(request: .login(param: params), onSuccess: { (dictionary) in
                    
                    let user: UserResponseModel = Mapper<UserResponseModel>().map(JSON: dictionary)!
                    print(user.toJSON())
                    AppContainer.shared.user.save(isLogin: true)
                    let account_type = user.accountType!
                    let username = user.userName!
                    let access_token = user.accessToken!
                    let email = user.email!
                    let profile_image = user.profileImage
                    let id = "\(String(describing: user.userId))"
                    
                    AppContainer.shared.user.save(email: email)
                    AppContainer.shared.user.save(token: access_token)
                    AppContainer.shared.user.save(userId: id)
                    AppContainer.shared.user.save(profileImage: profile_image)
                    AppContainer.shared.user.save(accountType: account_type)
                    AppContainer.shared.user.save(username: username)
                    
                    AppContainer.shared.user.save(user: user)
                    
                    AppRouter.shared.proceed()
                }) { (errorDictionary, _) in
                    self.hud.dismiss(animated: true)
                    if let msg = errorDictionary["message"] as? String {
                        AlertService.shared.alert(in: self, msg.capitalized)
                    }
                }
            } else {
                AlertService.shared.alert(in: self, "Incorrect password, please write correct one or consider reset now")
            }
        } else {
            AlertService.shared.alert(in: self, "Incorrect username, please write correct one.")
        }
    }
}
