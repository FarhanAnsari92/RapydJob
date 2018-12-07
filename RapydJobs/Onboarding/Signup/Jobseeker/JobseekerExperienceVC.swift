//
//  JobseekerExperienceVC.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 23/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit
import SwiftVideoBackground
import JGProgressHUD
import Alamofire
import SwiftyJSON

var experiences = [SignupExperience]()

class JobseekerExperienceVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let segueJobseekerEducationVC = "JobseekerEducationVC"
    private let segueJobseekerAddNewExperienceVC = "JobseekerAddNewExperiencesVC"
    
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
        label.text = "Jobseeker!"
        label.textAlignment = .left
        label.font = AppConstants.shared.appTitleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Experience"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.textAlignment = .left
        label.font = AppConstants.shared.appDescFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addExperienceButton: UIButton = {
        let btn = UIButton()
        btn.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        btn.setImage(#imageLiteral(resourceName: "plusIcon"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(addExperience), for: .touchUpInside)
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
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = AppConstants.shared.primaryGreenColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        super.viewDidLoad()
        self.toast = JYToast()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if EditProfileFlowManager.shared().isEditProfile {
            self.getExperience()
        } else {
            tableView.reloadData()
        }
        
        try? VideoBackground.shared.play(view: videoView, videoName: "Background", videoType: "mp4")
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
        
        view.addSubview(addExperienceButton)
        addExperienceButton.topAnchor.constraint(equalTo: view.topAnchor, constant: topFrameHeight + 20).isActive = true
        addExperienceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        addExperienceButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addExperienceButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(titleStackView)
        titleStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: topFrameHeight).isActive = true
        titleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        titleStackView.trailingAnchor.constraint(equalTo: addExperienceButton.leadingAnchor, constant: -30).isActive = true
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleMessageLabel)
        
        view.addSubview(nextButton)
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        tableView.register(JobseekerExperienceCell.self, forCellReuseIdentifier: JobseekerExperienceCell.identifier)
        
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
        
        let btnTitle = EditProfileFlowManager.shared().isEditProfile ? "EDUCATION >" : "SKIP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: btnTitle, style: .plain, target: self, action: #selector(skip))
    }
    
    var experinceArr: [ExperienceModel] = []
    func getExperience() {
        guard let user = AppContainer.shared.user.user, let exp = user.experience else {
            return
        }
        experinceArr = exp
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if EditProfileFlowManager.shared().isEditProfile {
            return self.experinceArr.count
        }
        return experiences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobseekerExperienceCell.identifier, for: indexPath) as! JobseekerExperienceCell
        
        if EditProfileFlowManager.shared().isEditProfile {
            let experience = self.experinceArr[indexPath.row]
            cell.populate(with: experience)
        } else {
            let experience = experiences[indexPath.row]
            cell.populate(with: experience)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let remove = UITableViewRowAction(style: .default, title: "Remove") { (action, index) in
            self.deleteExperience(row: indexPath.row)
        }
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, index) in
            self.updateExperience(row: indexPath.row)
        }
        remove.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        edit.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        return [remove, edit]
    }
    
    func updateExperience(row: Int) {
        if EditProfileFlowManager.shared().isEditProfile {
            let sb = UIStoryboard(name: "JobseekerSignup", bundle: nil) // JobseekerSignup
            let vc = sb.instantiateViewController(withIdentifier: "JobseekerAddNewExperiencesVC") as! JobseekerAddNewExperiencesVC
            vc.experienceModel = self.experinceArr[row]
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let sb = UIStoryboard(name: "JobseekerSignup", bundle: nil) // JobseekerSignup
            let vc = sb.instantiateViewController(withIdentifier: "JobseekerAddNewExperiencesVC") as! JobseekerAddNewExperiencesVC
            
            vc.experienceIndex = row
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func deleteExperience(row: Int) {
        if EditProfileFlowManager.shared().isEditProfile {
            let id = self.experinceArr[row].id ?? 0
           hud.show(in: view)
            _ = APIClient.callAPI(request: .deleteExperience(id: id), onSuccess: { (dictionary) in
                print(dictionary)
                
                self.hud.dismiss(animated: true)
                if let msg = dictionary["message"] as? String {
                    self.toast.isShow(msg)
                    let user = AppContainer.shared.user.user
                    user?.experience?.remove(at: row)
                    AppContainer.shared.user.save(user: user!)
                    self.getExperience()
                } else {
                    self.toast.isShow("Something went wring")
                }
                
            }) { (errorDictionary, _) in
                self.hud.dismiss(animated: true)
                self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
            }
        } else {
            experiences.remove(at: row)
            self.tableView.reloadData()
        }
        
    }
    
    @objc private func skip() {
        performSegue(withIdentifier: segueJobseekerEducationVC, sender: nil)
    }
    
    @objc private func addExperience() {
        performSegue(withIdentifier: segueJobseekerAddNewExperienceVC, sender: nil)
    }
    
    @objc private func moveToNext() {
        if experiences.count > 0 {
            hud.show(in: view)
            JobseekerSignupAPIService.shared.updateExperience(experience: experiences) { (error) in
                if let err = error {
                    self.hud.dismiss(animated: true)
                    print("Error : ", err)
                } else {
                    self.hud.dismiss(animated: true)
                    self.performSegue(withIdentifier: self.segueJobseekerEducationVC, sender: nil)
                }
            }
        } else {
            performSegue(withIdentifier: segueJobseekerEducationVC, sender: nil)
        }
    }
}
