//
//  EmployerUploadLogoVC.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 17/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit
import SwiftVideoBackground
import JGProgressHUD
import GTProgressBar

class EmployerUploadLogoVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var progressBar: GTProgressBar! {
        didSet {
            progressBar.layer.zPosition = 1
        }
    }

    private let segueEmployerMapVC = "EmployerMapVC"
    private var didImageSelected = false
    
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
        label.text = "Upload company logo"
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
        iv.image = #imageLiteral(resourceName: "uploaad_userpic")
        iv.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let companyLogo: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        iv.contentMode = .scaleAspectFill // .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 105
        iv.backgroundColor = AppConstants.shared.primaryBlueColor
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("SAVE", for: .normal)
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
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        try? VideoBackground.shared.play(view: videoView, videoName: "Background", videoType: "mp4")
    }
    
    @objc func navigateToAddressVC() {
        self.dismissToRootviewController()
    }

    private func setupViews() {
        self.toast = JYToast()
        if EditProfileFlowManager.shared().isEditProfile == true {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(navigateToAddressVC))
        } else {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
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
        
        backView.addSubview(companyLogo)
        companyLogo.heightAnchor.constraint(equalToConstant: 210).isActive = true
        companyLogo.widthAnchor.constraint(equalToConstant: 210).isActive = true
        companyLogo.centerXAnchor.constraint(equalTo: backView.centerXAnchor, constant: 0).isActive = true
        companyLogo.centerYAnchor.constraint(equalTo: backView.centerYAnchor, constant: 0).isActive = true
        
        backView.addSubview(iconImage)
        iconImage.centerXAnchor.constraint(equalTo: backView.centerXAnchor, constant: 0).isActive = true
        iconImage.centerYAnchor.constraint(equalTo: backView.centerYAnchor, constant: 0).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(getImage(_:)))
        companyLogo.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(getImage(_:)))
        iconImage.addGestureRecognizer(tap1)
        
        view.addSubview(doneButton)
        doneButton.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: 30).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        if EditProfileFlowManager.shared().isEditProfile {
            guard let user = AppContainer.shared.user.user else {
                return
            }
            if let profileImage = user.profileImage {
                self.companyLogo.setImageWithName(profileImage)
                self.iconImage.isHidden = true
            } else {
                self.iconImage.isHidden = false
            }
        }
        
    }
    
    @objc private func getImage(_ tap: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            iconImage.isHidden = true
            companyLogo.image = image
            companyLogo.contentMode = .scaleAspectFill
            didImageSelected = true
        }
        picker.dismiss(animated: true)
    }
    
    @objc private func moveToNext() {
        if didImageSelected {
            hud.show(in: view)
            EmployerSignupAPIService.shared.uploadPicture(image: companyLogo.image!) { (imageName, error, progress) in
                if let err = error {
                    self.toast.isShow(err.localizedDescription)
                    self.hud.dismiss(animated: true)
                    self.progressBar.isHidden = true
                } else if let prg = progress {
                  
                    self.progressBar.isHidden = false
                    self.progressBar.progress = CGFloat(prg)
                } else {
                    self.progressBar.isHidden = true
                    EmployerSignupAPIService.shared.updateImage(imageName: imageName!, completion: { (error) in
                        if let err = error {
                            self.toast.isShow(err.localizedDescription)
                            self.hud.dismiss(animated: true)
                            print("Error : ", err)
                        } else {
                            self.toast.isShow("Logo added successfully")
                            self.hud.dismiss(animated: true)
                            if EditProfileFlowManager.shared().isEditProfile {
                                self.dismissToRootviewController()
                            } else {
                                AppRouter.shared.proceed()
                            }
                        }
                    })
                }
            }
        } else {
            if EditProfileFlowManager.shared().isEditProfile {
                self.dismissToRootviewController()
            } else {
                AppRouter.shared.proceed()
            }
        }
    }
    
//    -(void)dismissToRootViewController
//    {
//    UIViewController *vc = self;
//    while (vc.presentingViewController) {
//    vc = vc.presentingViewController;
//    }
//    [vc dismissViewControllerAnimated:YES completion:nil];
//    }
    
    func dismissToRootviewController() {
        if self.presentingViewController != nil {
            self.dismiss(animated: false, completion: {
                self.navigationController!.popToRootViewController(animated: true)
            })
        }
        else {
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
}
