//
//  SocketService.swift
//  RapydJobs
//
//  Created by MuhammadKhan on 8/30/18.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import SocketIO
import Alamofire
import SwiftyJSON

struct SocketService {
    
    static let socketBaseUrl: URL = URL(string: "http://ec2-18-191-9-134.us-east-2.compute.amazonaws.com:8890")!
        
    static let manager = SocketManager(socketURL: socketBaseUrl)
    static let socket = manager.defaultSocket
    static var message: ((Any?) -> Void)?
    
    static func establishConnection() {
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            print("Socket Data : ", data)
            print("Socket Ack : ", ack)
            
            guard let userId = AppContainer.shared.user.user?.userId else {
                return
            }
            print(userId)
            connectToServerWithNickname(userId: "\(userId)")
        }
        
        socket.on(clientEvent: SocketClientEvent.error) { (data, ack) in
            print("socket connection error")
            print("Socket Data : ", data)
            print("Socket Ack : ", ack)
            //closeConnection()
        }
        
//        socket.on("message") { (data, ack) in
//            print(data)
//            message?(data)
//        }
        
        socket.connect()        
        socket.manager?.connect()
    }
    
    static func closeConnection() {
        print("Socket Disconnecting")
        socket.disconnect()
        socket.off("message")        
        socket.manager?.disconnect()        
    }
    
    static func connectToServerWithNickname(userId: String) {
        socket.emit("user_id", userId)        
    }
    
    static func getChatList(completion: @escaping ([ChatList]?, Error?) -> ()) {
        
        let url = URLConstants.shared.getEndPointURL("conversation")
        print(url)
        let token = AppContainer.shared.user.token!
        
        let header = [  "Authorization" : "Bearer \(token)",
                        "Accept" : "application/json",
                        "Content-Type" : "application/json"  ]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                print("🔥 Error : ", error)
                completion(nil, error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    
                    print("Chat List Response : ", json)
                    
                    let data = json.arrayValue
                    
                    var chatList = [ChatList]()
                    
                    for item in data {
                        
                        let name = item["name"].stringValue
                        let id = item["id"].stringValue
                        let updated_at = item["updated_at"].stringValue
                        let created_at = item["created_at"].stringValue
                        let job_id = item["job_id"].stringValue
                        let messages = item["messages"].arrayValue
                        let pivot = item["pivot"]
                        let users = item["users"].arrayValue
                        
                        let conversation_id = pivot["conversation_id"].intValue
                        let user_id = pivot["user_id"].intValue
                        
                        let pvt = Pivot(conversationId: conversation_id, userId: user_id)
                        
                        var msgs = [Message]()
                        var chatUsers = [ChatUser]()
                        
                        for msg in messages {
                            let replied_to = msg["replied_to"].stringValue
                            let updatedAt = msg["updated_at"].stringValue
                            let newId = msg["id"].intValue
                            let conversationId = msg["conversation_id"].stringValue
                            let sender_id = msg["sender_id"].intValue
                            let createdAt = msg["created_at"].stringValue
                            let message = msg["message"].stringValue
                            let type = msg["type"].stringValue
                            
                            let newMsg = Message(repliedTo: replied_to, updatedAt: updatedAt, id: newId, conversationId: conversationId, senderId: sender_id, createdAt: createdAt, message: message, type: type)
                            
                            msgs.append(newMsg)
                        }
                        
                        for user in users {
                            let updated_at = user["updated_at"].stringValue
                            let fcm = user["fcm"].stringValue
                            let email = user["email"].stringValue
                            let profile_image = user["profile_image"].stringValue
                            let device = user["device"].stringValue
                            let username = user["username"].stringValue
                            let latitude = user["latitude"].stringValue
                            let password_token = user["password_token"].stringValue
                            let status = user["status"].stringValue
                            let id = user["id"].intValue
                            let account_type = user["account_type"].stringValue
                            let created_at = user["created_at"].stringValue
                            let device_token = user["device_token"].stringValue
                            let longitude = user["longitude"].stringValue
                            
                            let userPivot = user["pivot"]
                            
                            let userConversation_id = userPivot["conversation_id"].intValue
                            let user_id = userPivot["user_id"].intValue
                            
                            let userPvt = Pivot(conversationId: userConversation_id, userId: user_id)
                            
                            let chatUser = ChatUser(accountType: account_type, createdAt: created_at, device: device, deviceToken: device_token, email: email, fcm: fcm, id: id, latitude: latitude, longitude: longitude, passwordToken: password_token, pivot: userPvt, profileImage: profile_image, status: status, updatedAt: updated_at, username: username)
                            
                            chatUsers.append(chatUser)
                        }
                        
                        let chat = ChatList(name: name, messages: msgs, id: id, updatedAt: updated_at, pivot: pvt, createdAt: created_at, jobId: job_id, users: chatUsers)
                        
                        chatList.append(chat)
                    }
                    completion(chatList, nil)
                    
                } catch {
                    print("Catch Error : ", error)
                    completion(nil, error)
                }
            }
        }
    }
    
    static func getChatConversation(conversationId: String, completion: @escaping ([Message]?, Error?) -> ()) {
        
        let url = URLConstants.shared.getEndPointURL("conversation/\(conversationId)")
        let token = AppContainer.shared.user.token!
        
        let header = [  "Authorization" : "Bearer \(token)",
                        "Accept" : "application/json",
                        "Content-Type" : "application/json"  ]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                print("🔥 Error : ", error)
                completion(nil, error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    print("Chat Conversation Response : ", json)
                    
                    let data = json["data"].arrayValue
                    
                    var msgs = [Message]()
                    
                    for item in data {
                        let replied_to = item["replied_to"].stringValue
                        let updatedAt = item["updated_at"].stringValue
                        let newId = item["id"].intValue
                        let conversationId = item["conversation_id"].stringValue
                        let sender_id = item["sender_id"].intValue
                        let createdAt = item["created_at"].stringValue
                        let message = item["message"].stringValue
                        let type = item["type"].stringValue
                        
                        let newMsg = Message(repliedTo: replied_to, updatedAt: updatedAt, id: newId, conversationId: conversationId, senderId: sender_id, createdAt: createdAt, message: message, type: type)
                        
                        msgs.append(newMsg)
                    }
                    completion(msgs, nil)
                } catch {
                    print("Catch Error : ", error)
                    completion(nil, error)
                }
            }
        }
    }
    
    static func sendMessage(type: String, message: String, conversationId: String) {
        
        let url = URLConstants.shared.getEndPointURL("message") //messages
        let token = AppContainer.shared.user.token!
        
        let header = [  "Authorization" : "Bearer \(token)",
                        "Accept" : "application/json",
                        "Content-Type" : "application/json"  ]
        
        let params: Parameters = [ "type" : type,
                                   "message" : message,
                                   "conversation_id" : conversationId ]
        print(params)
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            if let error = response.error {
                print("🔥 Error : ", error)
            } else {
                do {
                    let json = try JSON(data: response.data!)
                    print("🌎 Chat Message Response : ", json)
                } catch {
                    print("🔥 Catch Error : ", error)
                }
            }
        }
    }
}
