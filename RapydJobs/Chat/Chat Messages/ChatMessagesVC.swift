//
//  ChatMessagesVC.swift
//  RapydJobs
//
//  Created by MuhammadKhan on 8/26/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON
import IQKeyboardManagerSwift
import GrowingTextView
import JGProgressHUD

var chat: ChatList?

class ChatMessagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var footerView: UIView!

    let footerStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    @IBOutlet weak var sendButton: UIButton!
    var placeholderLabel : UILabel!
    @IBOutlet weak var messageInput: GrowingTextView!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var footerConstrains: NSLayoutConstraint!
    @IBOutlet weak var txtViewBottomBonstraint: NSLayoutConstraint!
    @IBOutlet weak var noMessageView: UIView!
    
    private let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        return hud
    }()
    
    var messages = [Message]()
    var jobSeekerId: Int?
    var conversationId: Int?
    var jobId: Int?
    var seekerPicture: String?
    var seekerName: String?
    var jobTitle: String?
    
    var currentPage = 1
    var lastPage = 0
    var isLoadMore: Bool = false
    var isLoading: Bool = false
    
    var toast: JYToast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.toast = JYToast()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        setupViews()
        SocketService.establishConnection()
        receiveMessage()
    }

    @objc func keyboardWillShow(notification: NSNotification) {
//        if let endFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
//            if #available(iOS 11, *) {
//                if keyboardHeight > 0 {
//                    keyboardHeight = keyboardHeight + view.safeAreaInsets.bottom
//                }
//            }
//            footerConstrains.constant =  endFrame.size.height
//            view.layoutIfNeeded()
//        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.footerView.frame.origin.y != 0 {
//                self.footerView.frame.origin.y = self.view.frame.height - 50 // keyboardSize.height
//            }
            footerConstrains.constant = 0
            view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {

        guard let userInfo = (notification as Notification).userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }
        let newHeight: CGFloat
        if #available(iOS 11.0, *) {
            newHeight = value.cgRectValue.height - view.safeAreaInsets.bottom
        } else {
            newHeight = value.cgRectValue.height
        }
        footerConstrains.constant = newHeight
        view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getConversation()
    }
    
    //MARK:- Get Conversation
    
    func getConversation() {
        
        guard let convId = self.conversationId else {
            print("Conversation id not found")
            return
        }
        
        self.isLoading = true
        hud.show(in: view)
        _ = APIClient.callAPI(request: .getConversation(conversationId: "\(String(describing: convId))", page: self.currentPage), onSuccess: { (dictionary) in
            print(dictionary)
            self.hud.dismiss(animated: true)
            self.isLoading = false
            
            let lastPage = dictionary["last_page"] as? Int ?? 0
            self.lastPage = lastPage + 1
            
            dictionary["current_page"] as? Int ?? 0
            dictionary["total"] as? Int ?? 0
            
            guard let data = dictionary["data"] as? [[String:Any]] else {
                print("No messages found")
                return
            }
            
            if data.count > 0 {
                self.currentPage += 1
                for item in data {
                    let replied_to = item["replied_to"] as? String ?? ""
                    let updatedAt = item["updated_at"] as? String ?? ""
                    let newId = item["id"] as? Int ?? 0
                    let conversationId = item["conversation_id"] as? String ?? ""
                    let sender_id = item["sender_id"] as? Int ?? 0
                    let createdAt = item["created_at"] as? String ?? ""
                    let message = item["message"] as? String ?? ""
                    let type = item["type"] as? String ?? ""
                    
                    let newMsg = Message(repliedTo: replied_to, updatedAt: updatedAt, id: newId, conversationId: conversationId, senderId: sender_id, createdAt: createdAt, message: message, type: type)
                    print(newMsg)
                    self.messages.append(newMsg)
                }
                
            }
            
            if self.messages.count == 0 {
                self.noMessageView.isHidden = false
            } else {
                self.noMessageView.isHidden = true
                self.messagesTableView.reloadData()
            }
        
        }) { (errorDictionary, _) in
            self.noMessageView.isHidden = !(self.messages.count == 0)
            self.isLoading = false
            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
            self.hud.dismiss(animated: true)
        }
        
        self.scrollToBottom()
        IQKeyboardManager.shared.enable = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SocketService.closeConnection()
        IQKeyboardManager.shared.enable = true
    }
    
    //MARK:- Receive Message
    func receiveMessage() {
        SocketService.socket.on("message") { [weak self] (data, ack) in
            print(data)
            
            let repliedTo = (data[0] as! [String: Any])["replied_to"] as? String ?? ""
            let id = (data[0] as! [String: Any])["id"] as? Int ?? 0
            let createdAt = (data[0] as! [String: Any])["created_at"] as? String ?? ""
            let updatedAt = (data[0] as! [String: Any])["updated_at"] as? String ?? ""
            let senderId = (data[0] as! [String: Any])["sender_id"] as? Int ?? 0
            let message = (data[0] as! [String: Any])["message"] as? String ?? ""
            let type = (data[0] as! [String: Any])["type"] as? String ?? ""
            let conversationId = (data[0] as! [String: Any])["conversation_id"] as? String ?? ""
            
            let chat = Message(repliedTo: repliedTo, updatedAt: updatedAt, id: id, conversationId: conversationId, senderId: senderId, createdAt: createdAt, message: message, type: type)
            
            self?.messages.append(chat)
            if self?.messages.count == 0 {
                self?.noMessageView.isHidden = false
            } else {
                self?.noMessageView.isHidden = true
                self?.messagesTableView.reloadData()
            }
            self?.moveToBottom(false)
            return
        }
        
        
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            if self.messages.count > 0 {
                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        }
    }
    
    private func setupViews() {
        messagesTableView.register(UINib(nibName: "ChatImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatImageTableViewCellID")
        
        messagesTableView.register(ScheduleChatTableViewCell.cellNib, forCellReuseIdentifier: ScheduleChatTableViewCell.cellIdentifier)
        
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationItem.rightBarButtonItems = self.rightBarButtonItems()
        
        
        messageInput.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Type a message"
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (messageInput.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        //messageInput.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (messageInput.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        
        
        messagesTableView.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.identifier)

    }
    
    func rightBarButtonItems() -> [UIBarButtonItem] {
        
        let optionBtn: UIButton = UIButton(type: UIButtonType.custom)
        optionBtn.setImage(UIImage(named: "option")?.withRenderingMode(.alwaysOriginal), for: .normal)
        optionBtn.addTarget(self, action: #selector(self.openAction), for: .touchUpInside)
        optionBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let optionBarBtn = UIBarButtonItem(customView: optionBtn)
        
        let imageBtn: UIButton = UIButton(type: UIButtonType.custom)
        imageBtn.setImage(UIImage(named: "ic_message")?.withRenderingMode(.alwaysOriginal), for: .normal)
        imageBtn.addTarget(self, action: #selector(self.sendImage), for: .touchUpInside)
        imageBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let imageBarBtn = UIBarButtonItem(customView: imageBtn)
        
        if AppContainer.shared.user.user?.accountType == "organization" {
            return [optionBarBtn, imageBarBtn]
        }
        return [imageBarBtn]
        
        
    }
    
    @objc func sendImage() {
        print("send image")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func openAction() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let makeOfferAction = UIAlertAction(title: "Make an offer", style: UIAlertActionStyle.default) { (action) in
            let storyboard = UIStoryboard(name: "Offer", bundle: nil)
            let offerVC = storyboard.instantiateViewController(withIdentifier: "MakeOfferViewControllerID") as! MakeOfferViewController
            
            offerVC.jobId = self.jobId
            offerVC.jobSeekerId = self.jobSeekerId
            
            self.navigationController?.pushViewController(offerVC, animated: true)
            
        }
        
        let callforAnAction = UIAlertAction(title: "Call for an interview", style: UIAlertActionStyle.default) { (action) in
            let storyboard = UIStoryboard(name: "Interview", bundle: nil)
            let interviewVC = storyboard.instantiateViewController(withIdentifier: "InterviewV2ViewControllerID") as! InterviewV2ViewController
            
            interviewVC.jobId = self.jobId
            interviewVC.jobTitle = self.jobTitle
            interviewVC.jobSeekerName = self.seekerName
            interviewVC.jobSeekerId = self.jobSeekerId
            self.navigationController?.pushViewController(interviewVC, animated: true)
        }
        
        actionSheet.addAction(makeOfferAction)
        actionSheet.addAction(callforAnAction)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "" || textView.text == "Type a message" {
            textView.textColor = .black
            textView.text = ""
            sendButton.setImage(UIImage(named: "sendMsg"), for: .normal)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Type a message"
            textView.textColor = .lightGray
            sendButton.setImage(UIImage(named: "sendMsg"), for: .normal)
        }
    }
    
    private func moveToBottom(_ animate: Bool = true) {
        if messages.count > 0  {
            let count = messages.count - 1
            let indexPath = IndexPath(row: count, section: 0)
            messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: animate)
            messagesTableView.reloadData()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            print("Load mare")
            self.isLoadMore = true
            if self.currentPage < lastPage, !self.isLoading {
                self.getConversation()
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if messages.count > 0 {
            
            guard let user = AppContainer.shared.user.user,
                let userId = user.userId else {
                    return UITableViewCell()
            }
            
            let message = messages[indexPath.row]
            if message.type == "file" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatImageTableViewCellID", for: indexPath) as! ChatImageTableViewCell
                cell.populate(message: message)
                cell.imageHandler = {
                    print("called")
                }
                
                return cell
                
            } else if message.type == "jobofferNotification" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleChatTableViewCell.cellIdentifier, for: indexPath) as! ScheduleChatTableViewCell
                cell.populateData(message: message, messageType: message.type)
                
                cell.viewInSchedule = { btn in
                    if btn.tag == 1 {  // receiver left
                        if AppContainer.shared.user.user?.accountType == "organization" {
                            
                        } else {
                            let vc = JobListSeekerViewController.getInstance()
                            EventFlowManager.shouldShowBackButton = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        // Download contract screen
                    } else {
                        if AppContainer.shared.user.user?.accountType == "organization" {
                            
                        } else {
                            let vc = JobListSeekerViewController.getInstance()
                            EventFlowManager.shouldShowBackButton = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        // Download contract screen
                    }
                }
                return cell
                
                
            } else if message.type == "hireNotification" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleChatTableViewCell.cellIdentifier, for: indexPath) as! ScheduleChatTableViewCell
                cell.populateData(message: message, messageType: message.type)
                cell.viewInSchedule = { btn in
                    if btn.tag == 1 {  // receiver left
                        if AppContainer.shared.user.user?.accountType == "organization" {
                            let sb = UIStoryboard(name: "HR", bundle: nil)
                            let vc = sb.instantiateViewController(withIdentifier: "ManageEmployeeViewControllerID") as! ManageEmployeeViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let vc = JobListSeekerViewController.getInstance()
                            EventFlowManager.shouldShowBackButton = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    } else {
                        if AppContainer.shared.user.user?.accountType == "organization" {
                           
                            let sb = UIStoryboard(name: "HR", bundle: nil)
                            let vc = sb.instantiateViewController(withIdentifier: "ManageEmployeeViewControllerID") as! ManageEmployeeViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        } else {
                            let vc = JobListSeekerViewController.getInstance()
                            EventFlowManager.shouldShowBackButton = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    }
                }
                
                return cell
                
            } else if message.type == "interviewNotification" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleChatTableViewCell.cellIdentifier, for: indexPath) as! ScheduleChatTableViewCell
                cell.populateData(message: message, messageType: message.type)
                cell.viewInSchedule = { btn in
                    if btn.tag == 1 {  // receiver left
                        // schedule interview vc
                        if AppContainer.shared.user.user?.accountType == "organization" {
                            let vc = InterviewsViewController.getInstance()
                            EventFlowManager.shouldShowBackButton = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let vc = ScheduleInterviewViewController.getInstance()
                            EventFlowManager.shouldShowBackButton = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    } else {
                     // schedule interview vc
                        if AppContainer.shared.user.user?.accountType == "organization" {
                            let vc = InterviewsViewController.getInstance()
                            EventFlowManager.shouldShowBackButton = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let vc = ScheduleInterviewViewController.getInstance()
                            EventFlowManager.shouldShowBackButton = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
                
                return cell
                
            } else {
                guard let cell = messagesTableView.dequeueReusableCell(withIdentifier: ChatMessageCell.identifier, for: indexPath) as? ChatMessageCell else { return UITableViewCell() }
                
                if message.id != userId {
                    cell.profileImage.setImageWithName(self.seekerPicture ?? "")
                } else {
                    cell.profileImage.setImageWithName(user.profileImage ?? "")
                }
                
                cell.populate(message: message)
                return cell
            }
            
            
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let message = messages[indexPath.row]
        if message.type == "file" {
            return 150
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    //MARK:- Send Message
    
    @IBAction private func sendMessageTapped(_ sender: UIButton) {
        
        if messageInput.text != "" { //} || messageInput.text != "Type a message" {
            
            view.endEditing(true)
            
            guard let convId = self.conversationId else {
                print("Conversation id not found")
                return
            }
            
            //SocketService.sendMessage(type: "text", message: messageInput.text!, conversationId: "\(String(describing: convId))")
            
            var param = [String:Any]()
            param["type"] = "text"
            param["message"] = messageInput.text!
            param["conversation_id"] = "\(String(describing: convId))"
            _ = APIClient.callAPI(request: .sendMessage(param: param), onSuccess: { (dictionary) in
                
                let message = dictionary["message"] as? String ?? "N/A"
                let userId = AppContainer.shared.user.user?.userId ?? 0
                
                let msg = Message(repliedTo: "", updatedAt: "", id: 0, conversationId: String(self.conversationId ?? 0), senderId: userId, createdAt: dictionary["created_at"] as? String ?? "" , message: message, type: "text")
                
                self.messages.append(msg)
                if self.messages.count == 0 {
                    self.noMessageView.isHidden = false
                } else {
                    self.noMessageView.isHidden = true
                    self.messagesTableView.reloadData()
                }
                self.moveToBottom()
                
            }) { (errorDictionary, _) in
                self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
            }
            
            messageInput.textColor = .lightGray
            messageInput.text = "Type a message"
            sendButton.setImage(UIImage(named: "sendMsg"), for: .normal)
            moveToBottom()
        }
    }
}

extension ChatMessagesVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        self.uploadPicture(image: chosenImage)
//        myImageView.contentMode = .scaleAspectFit //3
//        myImageView.image = chosenImage //4
        
        dismiss(animated:true, completion: nil) //5
    }
    
    func uploadPicture(image: UIImage) {
        
        let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
        
        let imageData = UIImageJPEGRepresentation(image, 0.2)!
        
        let url = URLConstants.shared.getEndPointURL("upload-attachment")
        
        let header = [  "Authorization" : "Bearer \(accessToken)",
            "Accept" : "application/json",
            "Content-Type" : "application/json" ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "attachment",fileName: "file.jpg", mimeType: "image/jpg")
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
                    print(response.result.value!)
                }
                
                upload.response { response in
                    print(response)
                    do {
                        _ = response.response?.statusCode
                        let json = try JSON(data: response.data!);
                        let name = json["name"].stringValue
                        guard let convId = self.conversationId else {
                            print("Conversation id not found")
                            return
                        }
                       // SocketService.sendMessage(type: "file", message: name, conversationId: "\(String(describing: convId))")
                        
                        var param = [String:Any]()
                        param["type"] = "file"
                        param["message"] = name
                        param["conversation_id"] = "\(String(describing: convId))"
                        _ = APIClient.callAPI(request: .sendMessage(param: param), onSuccess: { (dictionary) in
                            
                            
                            
                            
                            let message = dictionary["message"] as? String ?? "N/A"
                            let userId = AppContainer.shared.user.user?.userId ?? 0
                            
                            let msg = Message(repliedTo: "", updatedAt: "", id: 0, conversationId: String(self.conversationId ?? 0), senderId: userId, createdAt: dictionary["created_at"] as? String ?? "" , message: message, type: "file")
                            
                            self.messages.append(msg)
                            self.messagesTableView.reloadData()
                            self.moveToBottom()
                            
                            
                            
                            
                        }) { (errorDictionary, _) in
                            self.toast.isShow(errorDictionary["message"] as? String ?? "Something went wrong")
                        }
                        
                        print(json)
                    } catch {
                        print("could not parse.")
                    }
                        
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
}

extension ChatMessagesVC: GrowingTextViewDelegate {
    
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
