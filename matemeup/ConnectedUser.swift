//
//  ConnectedUser.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/29/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import Foundation

class ConnectedUser {
    var name: String
    var firstname: String
    var lastname: String
    var birthdate: String
    var avatar: String
    var gender: Int
    var location: String
    var isOpenChatDisabled: Bool
    static var instance: ConnectedUser? = nil
    
    private init() {
        name = ""
        firstname = ""
        lastname = ""
        avatar = "noavatar.png"
        birthdate = ""
        gender = 0
        location = ""
        isOpenChatDisabled = false
    }
    
    public static func getInstance() -> ConnectedUser {
        if instance == nil {
            instance = ConnectedUser()
        }
        return instance!
    }
    
    private static func emptyStringOnNil(_ field: Any) -> String {
        return (field as? String) == nil ? "" : (field as! String)
    }

    
    public static func getInstance(_ user: Dictionary<String, Any>) -> ConnectedUser {
        let ninstance: ConnectedUser = getInstance()
        
        ninstance.name = emptyStringOnNil(user["name"]!)
        ninstance.firstname = emptyStringOnNil(user["firstname"]!)
        ninstance.lastname = emptyStringOnNil(user["lastname"]!)
        ninstance.birthdate = emptyStringOnNil(user["birthdate"]!)
        ninstance.avatar = emptyStringOnNil(user["avatar"]!)
        if (user["gender"] as? Int) != nil {
            ninstance.gender = (user["gender"] as? Int)!
        }
        
        ninstance.location = emptyStringOnNil(user["location"]!)
        if (user["gender"] as? Int) != nil {
            ninstance.isOpenChatDisabled = (user["open_chat_disabled"] as! Int) == 1
        }
       
        return ninstance
    }
    
    public static func unset() {
        instance = nil
    }
    
    public static func set(_ user: Dictionary<String, Any>) -> ConnectedUser {
        return getInstance(user)
    }
}
