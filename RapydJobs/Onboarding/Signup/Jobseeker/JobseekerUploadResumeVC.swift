//
//  JobseekerUploadResumeVC.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 25/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit
import MobileCoreServices
import SwiftVideoBackground
import JGProgressHUD
import Alamofire
import SwiftyJSON
import GTProgressBar

class JobseekerUploadResumeVC: UIViewController, UIDocumentPickerDelegate {
    
    @IBOutlet weak var progressBar: GTProgressBar! {
        didSet {
            progressBar.layer.zPosition = 1
        }
    }
    
    let segueJobseekerUploadPicture = "JobseekerUploadPicture"
    
    var selectedContractURL: URL?
    
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
        label.text = "Upload Your CV"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.textAlignment = .left
        label.font = AppConstants.shared.appDescFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.4588235294, green: 0.7960784314, blue: 0.8509803922, alpha: 0.4)
        view.layer.cornerRadius = 120
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "upload_cv")
        iv.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let reumeImage: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 105
        iv.backgroundColor = AppConstants.shared.primaryBlueColor
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("UPLOAD", for: .normal)
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
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        view.addSubview(titleStackView)
        titleStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: topFrameHeight).isActive = true
        titleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        titleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleMessageLabel)
        
        view.addSubview(backView)
        backView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        backView.widthAnchor.constraint(equalToConstant: 240).isActive = true
        backView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        backView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        
        backView.addSubview(reumeImage)
        reumeImage.heightAnchor.constraint(equalToConstant: 210).isActive = true
        reumeImage.widthAnchor.constraint(equalToConstant: 210).isActive = true
        reumeImage.centerXAnchor.constraint(equalTo: backView.centerXAnchor, constant: 0).isActive = true
        reumeImage.centerYAnchor.constraint(equalTo: backView.centerYAnchor, constant: 0).isActive = true
        
        backView.addSubview(iconImage)
        iconImage.centerXAnchor.constraint(equalTo: backView.centerXAnchor, constant: 0).isActive = true
        iconImage.centerYAnchor.constraint(equalTo: backView.centerYAnchor, constant: 0).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        iconImage.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(getResume(_:)))
        reumeImage.addGestureRecognizer(tap)
        iconImage.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(getResume(_:)))
        iconImage.addGestureRecognizer(tap1)
        
        view.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: 30).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let btnTitle = EditProfileFlowManager.shared().isEditProfile ? "PROFILE PICTURE >" : "SKIP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: btnTitle, style: .plain, target: self, action: #selector(skip))
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            controller.dismiss(animated: true, completion: nil)
            return
        }
        self.selectedContractURL = url
        self.iconImage.image = #imageLiteral(resourceName: "iconDocument")
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let urlString = "\(url)"
        
        if urlString.contains("pdf") {
            hud.show(in: view)
            do {
                let data = try Data(contentsOf: url)
                JobseekerSignupAPIService.shared.uploadResume(fileData: data) { (_, error, progress) in
                    if let err = error {
                        AlertService.shared.alert(in: self, err.localizedDescription)
                        self.hud.dismiss(animated: true)
                        self.progressBar.isHidden = true
                    } else if let prg = progress {
                        self.progressBar.isHidden = false
                        self.progressBar.progress = CGFloat(prg)
                    } else {
                        self.progressBar.isHidden = true
                        self.hud.dismiss(animated: true)
                        AlertService.shared.alert(in: self, "Congratulations, your resume uploaded successfully")
                    }
                }
            } catch {
                print("Catch Document Error : ", error)
            }
        } else {
            AlertService.shared.alert(in: self, "The selected document is not a PDF please select a PDF document to upload")
        }
    }
    
    @objc private func getResume(_ tap: UITapGestureRecognizer) {
        let pciker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeText), String(kUTTypePlainText)], in: .import)
        pciker.delegate = self
        pciker.modalPresentationStyle = .formSheet
        self.present(pciker, animated: true, completion: nil)
    }
    
    @objc private func skip() {
        performSegue(withIdentifier: segueJobseekerUploadPicture, sender: nil)
    }
    
    @objc private func moveToNext() {
        
        // Upload here
        guard let url = self.selectedContractURL else {
            self.toast.isShow("Select File")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            self.uploadDoc(data: data, isPdf: url.absoluteString.contains("pdf"))
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        
        //performSegue(withIdentifier: segueJobseekerUploadPicture, sender: nil)
    }
    
    func uploadDoc(data: Data, isPdf: Bool) {
        let fileName = "cv.pdf" // self.txtFileName.text
        let mimeType = isPdf ? "application/pdf" : "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        print(mimeType)
        
        guard let token = AppContainer.shared.user.user?.accessToken else {
            return
        }
        
        let url = URLConstants.shared.getEndPointURL("store-cv")
        print(url)
        let header = [  "Authorization" : "Bearer \(token)",
            "Accept" : "application/json",
            "Content-Type" : "application/json" ]
        
        print(header)
        
        let param: Parameters = ["cv": fileName]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            
            multipartFormData.append(data, withName: "cv",fileName: fileName, mimeType: "application/pdf")
            
            for(key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        },
                         to: url,
                         method: .post,
                         headers: header)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    self.progressBar.isHidden = false
                    self.progressBar.progress = CGFloat(progress.fractionCompleted)
                })
                
                upload.responseJSON { response in
                    print(response.result.value!)
                }
                
                upload.response { response in
                    print(response)
                    self.progressBar.isHidden = true
                    do {
                        _ = response.response?.statusCode
                        let json = try JSON(data: response.data!);
                        print(json)
                        
                        if let data = json.dictionaryObject {
                            print(data)
                            let cv = data["cv"] as? String ?? ""
                            print(cv)
                            let param = ["jobseeker_cv": data]
                            print(param)
                            self.uploadResume(pdfName: cv)
                        }
                        
                        
                        self.toast.isShow("Uploaded successfully")
                    } catch {
                        self.toast.isShow("Something went wrong")
                        self.progressBar.isHidden = true
                    }
                    
                }
                
            case .failure(let encodingError):
                self.toast.isShow("Something went wrong")
                self.progressBar.isHidden = true
                print(encodingError)
            }
        }
    }
    
    func uploadResume(pdfName: String) {
        
        //let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
        guard let accessToken = AppContainer.shared.user.user?.accessToken else {
            return
        }
        
        let url = URLConstants.shared.getEndPointURL("user")
        
        let header = [  "Authorization" : "Bearer \(accessToken)",
            "Accept" : "application/json",
            "Content-Type" : "application/json" ]

        let param1: Parameters = ["cv": pdfName]
        
        let params: Parameters = [ "jobseeker_cv" : param1] as [String:Any] //related_fielfds
        print(params)
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                self.toast.isShow(error.localizedDescription)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    print(json.dictionaryObject)
                    
                    
                    if let rawObj = json.dictionaryObject {
                        
                        let user = AppContainer.shared.user.user
                        user?.jobSeeker?.cv = pdfName
                        print(user?.toJSON())
                        
                        AppContainer.shared.user.save(user: user!)
                        
                        self.performSegue(withIdentifier: self.segueJobseekerUploadPicture, sender: nil)
                        
                    }
                    
                } catch let error as NSError {
                    self.toast.isShow(error.localizedDescription)
                }
            }
        }
        
    }
    
}
