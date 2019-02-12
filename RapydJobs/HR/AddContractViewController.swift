//
//  AddContractViewController.swift
//  RapydJobs
//
//  Created by Mohammad Farhan on 11/9/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON
import SkyFloatingLabelTextField
import GTProgressBar

class AddContractViewController: UIViewController, UIDocumentPickerDelegate {

    @IBOutlet weak var progressBar: GTProgressBar! {
        didSet {
            progressBar.layer.zPosition = 1
        }
    }
    @IBOutlet weak var addImg: UIImageView!
    @IBOutlet weak var txtFileName: SkyFloatingLabelTextField!
    @IBOutlet weak var uploadBtn: UIButton!
    
    var selectedContractURL: URL?
    var toast: JYToast!;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toast = JYToast();
        self.setupView()
        
    }
    
    func setupView() {
        self.title = "Upload Contract"
        view.backgroundColor = Constants.Colors.primaryGreenColor
        
        uploadBtn.setTitle("UPLOAD", for: .normal)
        uploadBtn.titleLabel?.font = AppConstants.shared.buttonFont
        uploadBtn.backgroundColor = AppConstants.shared.buttonGradientStart
        uploadBtn.layer.cornerRadius = 20
        uploadBtn.translatesAutoresizingMaskIntoConstraints = false
        uploadBtn.addTarget(self, action: #selector(upload), for: .touchUpInside)
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.addContract))
        self.addImg.addGestureRecognizer(gesture)
    }
    
    @objc func upload(_ sender: UIButton) {
        guard let url = self.selectedContractURL else {
            self.toast.isShow("Select a contract to upload.")
            return
        }
        
        let fileName = self.txtFileName.text
        
        if fileName?.count == 0 {
            self.toast.isShow("Contract title is required")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            self.uploadDoc(data: data, isPdf: url.absoluteString.contains("pdf"))
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        
        
    }
    
    @objc func addContract() {
        
        let pciker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeText), String(kUTTypePlainText)], in: .import)
        pciker.delegate = self
        pciker.modalPresentationStyle = .formSheet
        self.present(pciker, animated: true, completion: nil)
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
        
        controller.dismiss(animated: true, completion: nil)
    }
    
}

extension AddContractViewController {
    
    func uploadResume(fileData: Data, completion: @escaping (String?, Error?) -> ()) {
        
        let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
        
        let url = URLConstants.shared.getEndPointURL("store-cv")
        
        let header = [  "Authorization" : "Bearer \(accessToken)",
            "Accept" : "application/json",
            "Content-Type" : "application/json" ]
        
        let params: Parameters = [ "cv" : "cv.pdf" ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(fileData, withName: "profile_image",fileName: "cv.pdf", mimeType: "application/pdf")
            
            for (key, value) in params {
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
                })
                upload.responseJSON { response in
                    
                    if let error = response.error {
                        completion(nil, error)
                    } else {
                        do {
                            let json = JSON(response.data!)
                            print("Response : ", json)
                        }
                    }
                }
            case .failure(let encodingError):
                completion(nil, encodingError)
            }
        }
    }
    
    func uploadDoc(data: Data, isPdf: Bool) {
        let fileName = self.txtFileName.text
        
        let mimeType = isPdf ? "application/pdf" : "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        
        print(mimeType)
        
        guard let token = AppContainer.shared.user.user?.accessToken else {
            return
        }
        
        let url = URLConstants.shared.getEndPointURL("store-contract")
        print(url)
        let header = [  "Authorization" : "Bearer \(token)",
            "Accept" : "application/json",
            "Content-Type" : "application/json" ]
        
        print(header)
        
        let param: Parameters = ["contract_name": fileName]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            
            multipartFormData.append(data, withName: "contract",fileName: fileName!, mimeType: "application/pdf")
            
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
                    self.progressBar.isHidden = false
                    self.progressBar.progress = CGFloat(progress.fractionCompleted)
                })
                
                upload.responseJSON { response in
                    print(response.result.value!)
                }
                
                upload.response { response in
                    self.progressBar.isHidden = true
                    
                    do {
                        _ = response.response?.statusCode
                        let json = try JSON(data: response.data!);
                        
                        if let dictionary = json.dictionaryObject,
                            let dict = dictionary["errors"] as? [String:Any],
                            let arr = dict["contract"] as? NSArray {
                            let errorMessage = arr.firstObject as? String ?? ""
                            self.toast.isShow(errorMessage)
                        } else {
                            self.toast.isShow("Uploaded successfully")
                        }
                    } catch {
                        self.toast.isShow("Something went wrong.")
                    }
                    
                }
                
            case .failure(let encodingError):
                self.progressBar.isHidden = true
                print(encodingError)
                self.toast.isShow(encodingError.localizedDescription)
            }
        }
    }
    
}
