//
//  NewMessageNotifier.swift
//  matemeup
//
//  Created by Mehdi Meddour on 5/14/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import Foundation

class NewMessageNotifier {
    private static var instance: NewMessageNotifier? = nil
    private var currentUserId: Int
    private var socket: MMUWebSocket
    private var newUserMessageListeners: [Callback]
    private var newUserListeners: [Callback]
    private var newConnectedMessageListeners: [Callback]
    private var delUserListeners: [Callback]
    private var userMessages: [Int: (User, Int, Message?)]
    
    private init() {
        currentUserId = -1
        newUserMessageListeners = []
        newUserListeners = []
        newConnectedMessageListeners = []
        delUserListeners = []
        userMessages = [:]
        socket = MMUWebSocket.getInstance()
        socket.on(message: "global.chat.new", callback: Callback(
            success: onNewMessage,
            fail: {data in print("error")}
        ))
    }
    
    private func notifyNewUser(_ info: (User, Int, Message?)) {
        for listener in newUserListeners {
            listener.success(["user": info.0, "count": info.1, "lastMessage": info.2 as Any, "instance": self])
        }
    }
    
    private func notifyNewUserMessage(_ info: (User, Int, Message?)) {
        for listener in newUserMessageListeners {
            listener.success(["user": info.0, "count": info.1, "lastMessage": info.2 as Any, "instance": self])
        }
    }
    
    private func notifyNewConnectedMessage(_ info: (User, Int, Message?)) {
        for listener in newConnectedMessageListeners {
            listener.success(["user": info.0, "count": info.1, "lastMessage": info.2 as Any, "instance": self])
        }
    }
    
    private func notifyDelUser(_ info: (User, Int, Message?)) {
        for listener in delUserListeners {
            listener.success(["user": info.0, "count": info.1, "lastMessage": info.2 as Any, "instance": self])
        }
    }
    
    private func onNewMessage(_ data: Any) {
        let message = data as! Message
        let userId = message["senderUserId"] as! Int
        
        if userMessages[userId] == nil {
            userMessages[userId] = (["id": userId, "name": message["senderUserName"]!, "avatar": message["senderUserAvatar"]!], 1, message)
            if currentUserId != userId {
                notifyNewUser(userMessages[userId]!)
            }
        }
        userMessages[userId]!.1 += 1
        if currentUserId != userId {
            notifyNewUserMessage(userMessages[userId]!)
        } else {
            notifyNewConnectedMessage(userMessages[userId]!)
        }
    }
    
    public func setUsers(_ users: [User]) {
        for user in users {
            let userId: Int = user["id"] as! Int
            let userMsgCount: Int = user["unseen_messages_count"] as! Int
            
            if userMessages[userId] == nil && userMsgCount > 0 {
                userMessages[userId] = (user, userMsgCount, nil)
                if currentUserId != userId {
                    notifyNewUser(userMessages[userId]!)
                }
            } else if userMsgCount > 0 {
                let currUser: (User, Int, Message?) = (userMessages[userId])!
                userMessages[user["id"] as! Int] = (currUser.0, currUser.1 + userMsgCount, nil)
            }
        }
    }
    
    public func setCurrentUser(_ user: User?) {
        self.currentUserId = user == nil ? -1 : user!["id"] as! Int
    }
    
    public func delUser(_ user: User) {
        let userId: Int = user["id"] as! Int
        
        if userMessages[userId] != nil {
            let user = userMessages[userId]!
            
            userMessages.removeValue(forKey: userId)
            print(userMessages)
            notifyDelUser(user)
        }
    }
    
    public static func getInstance() -> NewMessageNotifier {
        if instance == nil {
            instance = NewMessageNotifier()
        }
        return instance!
    }
    
    public func getUserLength() -> Int {
        var i: Int = 0
        
        for _ in userMessages {
            i = i + 1
        }
        
        return i
    }
    
    public func off(message: String) {
        switch message {
        case "newUserMessage":
            print("OFFnewUserMessage")
        case "newUser":
            print("OFFnewUser")
        case "newConnectedMessage":
            print("OFFnewConnectedMessage")
        case "delMessage":
            print("OFFdelMessage")
        default:
            print("OFFUnknow value")
        }
    }
    
    public func on(message: String, callback: Callback) {
        switch message {
        case "newUserMessage":
            newUserMessageListeners.append(callback)
        case "newUser":
            newUserListeners.append(callback)
        case "newConnectedMessage":
            newConnectedMessageListeners.append(callback)
        case "delUser":
            delUserListeners.append(callback)
        default:
            print("Unknow value")
        }
    }
}
