//
//  JobseekerAddNewLanguageVC.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 25/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit
import SwiftVideoBackground
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON
import ObjectMapper

class JobseekerAddNewLanguageVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    private var pickerView: UIPickerView!
    private let pickerData = [ "Beginner level", "Conversational level", "Business level", "Fluent level"]
    var languageModel: LanguageModel?
    var languageIndex: Int?
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
        label.text = "Add New Language"
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
    
    private let languageInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Language"
        input.title = "Language"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let languageLevelInput: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField()
        input.placeholder = "Level"
        input.title = "Level"
        input.font = AppConstants.shared.textFieldFont
        input.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        input.lineColor = AppConstants.shared.primaryBlueColor
        input.selectedLineColor = AppConstants.shared.primaryBlueColor
        input.selectedTitleColor = AppConstants.shared.primaryBlueColor
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let dropdownImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_dropdown")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        try? VideoBackground.shared.play(view: videoView, videoName: "Background", videoType: "mp4")
    }
    
    private func setupViews() {
        
//        languageLevelInput.text = "Expert"
        
        self.toast = JYToast()
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
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
        
        dropdownImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        dropdownImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        languageLevelInput.rightView = dropdownImage
        languageLevelInput.rightViewMode = .always
        languageLevelInput.inputView = pickerView
        
        mainStackView.addArrangedSubview(languageInput)
        mainStackView.addArrangedSubview(languageLevelInput)
        
        languageInput.delegate = self
        languageLevelInput.delegate = self
        
        view.addSubview(addButton)
        addButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20).isActive = true
        addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        if let lngModel = languageModel {
            languageInput.text = lngModel.language ?? ""
            languageLevelInput.text = lngModel.level ?? ""
            addButton.setTitle("UPDATE", for: .normal)
        }
        
        if let index = self.languageIndex {
          let lng = languages[index]
            languageInput.text = lng.language
            languageLevelInput.text = lng.level
            addButton.setTitle("UPDATE", for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == languageInput {
            languageInput.resignFirstResponder()
            languageLevelInput.becomeFirstResponder()
        } else if textField == languageLevelInput {
            languageLevelInput.resignFirstResponder()
        }
        return true
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
        languageLevelInput.text = pickerData[row]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func goBack() {
        if languageInput.text != "" {
            if languageLevelInput.text != "" {
                
                if EditProfileFlowManager.shared().isEditProfile {
                    if let _ = self.languageModel {
                     self.updateLanguage()
                    } else {
                     self.addLanguage()
                    }
                } else {
                
                    let language = SignupLanguage(language: languageInput.text!, level: languageLevelInput.text!)
                    if let index = self.languageIndex {
                        languages.remove(at: index)
                    }
                    languages.append(language)
                    navigationController?.popViewController(animated: true)
                    
                }
                
                
            } else {
                AlertService.shared.alert(in: self, "Please insert a level of selected language to add")
            }
        } else {
            AlertService.shared.alert(in: self, "Please insert a language to add")
        }
    }
    
    func updateLanguage() {
        guard let id = self.languageModel!.id else {
            return
        }
        let param = ["language": self.languageInput.text!, "level": self.languageLevelInput.text!]
        print(param)
        _ = APIClient.callAPI(request: APIClient.updateLanguage(param: param, id: id), onSuccess: { (dictionary) in
            print(dictionary)
            
            guard let lngModel: LanguageModel = Mapper<LanguageModel>().map(JSON: dictionary) else {
                return
            }
            print(lngModel.toJSON())
            let user = AppContainer.shared.user.user
            
            if let index = user?.language?.firstIndex(where: {$0.id == lngModel.id}) {
                user?.language?.remove(at: index)
            }
            self.toast.isShow("Language updated successfully")
            user?.language?.append(lngModel)
            AppContainer.shared.user.save(user: user!)
            Helper.delay(0.3, closure: {
                self.navigationController?.popViewController(animated: true)
            })
            
        }, onFailure: { (errorDictionary, _) in
            print(errorDictionary)
        })
    }

    func addLanguage() {
        
        let param: [Parameters] = [
            ["language": self.languageInput.text!, "level": self.languageLevelInput.text!]
        ]
        print(param)
        let parameter = ["languages": param]
        print(parameter)
        
        _ = APIClient.callAPI(request: .addLanguage(param: parameter), onSuccess: { (dictionary) in
            print(dictionary)
            guard let languageArray = dictionary["data"] as? [[String:Any]] else {
                return
            }
            let languageModel: [LanguageModel] = Mapper<LanguageModel>().mapArray(JSONArray: languageArray)
            let user = AppContainer.shared.user.user
            if user?.language == nil {
               user?.language = languageModel
            } else {
                user?.language?.append(languageModel.first!)
            }
            self.toast.isShow("Language added successfully")
            AppContainer.shared.user.save(user: user!)
            Helper.delay(0.3, closure: {
                self.navigationController?.popViewController(animated: true)
            })
            
        }) { (errorDictionary, _) in
            print(errorDictionary)
        }
        
    }
    
}
