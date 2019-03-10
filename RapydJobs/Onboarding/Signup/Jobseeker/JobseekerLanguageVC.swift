//
//  JobseekerLanguageVC.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 25/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit
import SwiftVideoBackground
import JGProgressHUD
import Alamofire
import SwiftyJSON

var languages = [SignupLanguage]()

class JobseekerLanguageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let segueJobseekerAddNewLanguageVC = "JobseekerAddNewLanguageVC"
    private let segueJobseekerUploadResumeVC = "JobseekerUploadResumeVC"
    
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
        label.text = "Your Language Skills"
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
    
    let addLanguageButton: UIButton = {
        let btn = UIButton()
        btn.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        btn.setImage(#imageLiteral(resourceName: "plusIcon"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(addLanguage), for: .touchUpInside)
        return btn
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
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        return hud
    }()
    
    var toast: JYToast!
    override func viewDidLoad() {
        self.toast = JYToast()
        super.viewDidLoad()

        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if EditProfileFlowManager.shared().isEditProfile {
            self.getLanguage()
        } else {
            tableView.reloadData()
        }
        
        try? VideoBackground.shared.play(view: videoView, videoName: "Background", videoType: "mp4")
    }
    
    var languageArr: [LanguageModel] = []
    func getLanguage() {
        guard let user = AppContainer.shared.user.user, let lng = user.language else {
            return
        }
        languageArr = lng
        self.tableView.reloadData()
    }
    
    private func setupViews() {
        
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
        
        view.addSubview(addLanguageButton)
        addLanguageButton.topAnchor.constraint(equalTo: view.topAnchor, constant: topFrameHeight + 20).isActive = true
        addLanguageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        addLanguageButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addLanguageButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(titleStackView)
        titleStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: topFrameHeight).isActive = true
        titleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        titleStackView.trailingAnchor.constraint(equalTo: addLanguageButton.leadingAnchor, constant: -30).isActive = true
        
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleMessageLabel)
        titleStackView.addArrangedSubview(separator)
        
        view.addSubview(nextButton)
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        tableView.register(JobseekerLanguageCell.self, forCellReuseIdentifier: JobseekerLanguageCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        tableView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20).isActive = true
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let btnTitle = EditProfileFlowManager.shared().isEditProfile ? "RESUME >" : "SKIP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: btnTitle, style: .plain, target: self, action: #selector(skip))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if EditProfileFlowManager.shared().isEditProfile {
            return self.languageArr.count
        }
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobseekerLanguageCell.identifier, for: indexPath) as! JobseekerLanguageCell
        
        if EditProfileFlowManager.shared().isEditProfile {
            let language = self.languageArr[indexPath.row]
            cell.populate(with: language)
        } else {
            let language = languages[indexPath.row]
            cell.populate(with: language)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let remove = UITableViewRowAction(style: .default, title: "Remove") { (action, index) in
            AlertService.shared.alert(in: self, "Are you sure you want to delete this language?", success: {
                self.deleteLanguage(row: indexPath.row)
            })
        }
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, index) in
            
            self.updateLanguage(row: indexPath.row)
        
        }
        remove.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        edit.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        return [remove, edit]
    }
    
    func updateLanguage(row: Int) {
        if EditProfileFlowManager.shared().isEditProfile {
            let sb = UIStoryboard(name: "JobseekerSignup", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "JobseekerAddNewLanguageVC") as! JobseekerAddNewLanguageVC
            vc.languageModel = self.languageArr[row]
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let sb = UIStoryboard(name: "JobseekerSignup", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "JobseekerAddNewLanguageVC") as! JobseekerAddNewLanguageVC
            vc.languageIndex = row
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func deleteLanguage(row: Int) {
        if EditProfileFlowManager.shared().isEditProfile {
            guard let id = self.languageArr[row].id else {
                return
            }
            
            let accessToken = AppContainer.shared.user.user?.accessToken ?? ""
            let endPoint = "delete-language/\(id)"
            let url = URLConstants.shared.getEndPointURL(endPoint)
            print(url)
            
            let header = [  "Authorization" : "Bearer \(accessToken)",
                "Accept" : "application/json",
                "Content-Type" : "application/json" ]
            print(header)
            
            Alamofire.request(url, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: header).response { (response) in
                if let error = response.error {
                    print(error.localizedDescription)
                } else {
                    if response.response?.statusCode == 200 {
                        do {
                            let json = try JSON(data: response.data!)
                            
                            if let dictionary = json.dictionaryObject {
                                print(dictionary["message"] as! String)
                                
                                if let msg = dictionary["message"] as? String {
                                    self.toast.isShow("Language deleted successfully")
                                    let user = AppContainer.shared.user.user
                                    user?.language?.remove(at: row)
                                    AppContainer.shared.user.save(user: user!)
                                    self.getLanguage()
                                } else {
                                    self.toast.isShow("Something went wring")
                                }
                                
                                
                            }
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    } else {
                        print("Something went wrong")
                    }
                    
                }
            }
        } else {
            languages.remove(at: row)
            self.tableView.reloadData()
        }
    }
    
    @objc private func addLanguage() {
        performSegue(withIdentifier: segueJobseekerAddNewLanguageVC, sender: nil)
    }
    
    @objc private func skip() {
        performSegue(withIdentifier: segueJobseekerUploadResumeVC, sender: nil)
    }
    
    @objc private func moveToNext() {
        if languages.count > 0 {
            hud.show(in: view)
            JobseekerSignupAPIService.shared.updateLanguage(language: languages) { (error) in
                if let err = error {
                    self.hud.dismiss(animated: true)
                    print("Error : ", err)
                } else {
                    self.hud.dismiss(animated: true)
                    self.toast.isShow("Language added successfully")
                    Helper.delay(0.3, closure: {
                        self.performSegue(withIdentifier: self.segueJobseekerUploadResumeVC, sender: nil)
                    })
                }
            }
        } else {
            performSegue(withIdentifier: segueJobseekerUploadResumeVC, sender: nil)
        }
    }
}
