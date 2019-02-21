//
//  ChatListVC.swift
//  RapydJobs
//
//  Created by MuhammadKhan on 8/26/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import UIKit
import JGProgressHUD

class ChatListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let messagesTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        return hud
    }()
    
    var chatLists = [ChatList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        hud.show(in: view)
        SocketService.getChatList { [weak self] (chatLists, error) in
            if let err = error {
                self?.hud.dismiss(animated: true)
                print("🔥 Error : ", err)
            } else {
                self?.hud.dismiss(animated: true)
                self?.chatLists = chatLists!
                self?.messagesTableView.reloadData()
            }
        }        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //SocketService.establishConnection()
        
//        let userId = AppContainer.shared.user.userId
//        SocketService.connectToServerWithNickname(userId: userId)
    }
//
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppContainer.shared.notificationContainer.save(Chat: false)
    }
    

    private func setupViews() {
        
        navigationItem.title = "Messages"
        view.backgroundColor = Constants.Colors.primaryGreenColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let topFrameHeight = UIApplication.shared.statusBarFrame.height + 44
        
        view.addSubview(mainView)
        mainView.topAnchor.constraint(equalTo: view.topAnchor, constant: topFrameHeight).isActive = true
        mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        mainView.addSubview(messagesTableView)
        messagesTableView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0).isActive = true
        messagesTableView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0).isActive = true
        messagesTableView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0).isActive = true
        messagesTableView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0).isActive = true
        messagesTableView.separatorColor = .clear
        
        messagesTableView.register(ChatListCell.self, forCellReuseIdentifier: ChatListCell.identifier)
        
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = messagesTableView.dequeueReusableCell(withIdentifier: ChatListCell.identifier, for: indexPath) as? ChatListCell else { return UITableViewCell() }
        
        if chatLists.count > 0 {
            
            let chat = chatLists[indexPath.row]
            
            cell.populate(chat: chat)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //chat = chatLists[indexPath.row]
        let item = chatLists[indexPath.row]
        //let chatVC = ChatMessagesVC()
        let sb = UIStoryboard(name: "Chat", bundle: nil)
        let chatVC = sb.instantiateViewController(withIdentifier: "ChatMessagesVC") as! ChatMessagesVC
        
        guard let userId = AppContainer.shared.user.user?.userId else {
            return
        }
        
        guard let user = item.users.filter({ $0.id != userId }).first else {
            return
        }
        
        chatVC.conversationId = item.pivot.conversationId
        chatVC.jobId = Int(item.jobId)
        chatVC.jobSeekerId = user.pivot.userId
        chatVC.seekerName = user.username
        chatVC.seekerPicture = user.profileImage
        chatVC.jobTitle = item.name
        chatVC.title = user.username
        
        print(item)
        
        self.navigationController?.pushViewController(chatVC, animated: true)
        
    }
}
