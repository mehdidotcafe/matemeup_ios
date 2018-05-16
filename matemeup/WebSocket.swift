//
//  WebSocket.swift
//  matemeup
//
//  Created by Mehdi Meddour on 4/17/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import SocketIO

class WebSocket {
    private let BASE_URL: String
    private var socket: SocketIOClient? = nil
    private var manager: SocketManager? = nil
    private var isConnected: Bool = false
    private var currentRequests: [String] = []
    private var cachedListeners: [(String, Callback?, String?, Bool)] = []
    private var cachedRequest: [(String, Any, Callback?)] = []
    private var customIdList: [String: UUID] = [:]
  
    init(url: String) {
        BASE_URL = url
    }
    
    func off(message: String) {
        socket?.off(message)
    }
    
    func off(customId: String) {
        if customIdList[customId] != nil {
            socket?.off(id: customIdList[customId]!)
        }
    }
    
    func on(message: String, callback: Callback?, customId: String?) {
        return on(message: message, callback: callback, customId: customId, isOneTime: false)
    }
    
    func on(message: String, callback: Callback?) {
        return on(message: message, callback: callback, customId: nil, isOneTime: false)
    }
    
    func on(message: String, callback: Callback?, customId: String?, isOneTime: Bool) {
        if isConnected == true {
            var tmpId: UUID? = nil
            let id: UUID = socket!.on(message, callback: { data, ack in
                if isOneTime == true {
                    self.socket!.off(id: tmpId!)
                }
                if self.currentRequests.contains(message) {
                    self.currentRequests = self.currentRequests.filter{$0 != message}
                }
                if callback != nil {
                    callback!.success((data as [Any])[0])
                }
            })
            tmpId = id
            if customId != nil {
                customIdList[customId!] = id
            }
        } else {
            cachedListeners.append((message, callback, customId, isOneTime))
        }
    }
    
    func execCachedListeners() {
        cachedListeners.forEach({ (message, callback, customId, isOneTime) in
            self.on(message: message, callback: callback, customId: customId, isOneTime: isOneTime)
        })
        cachedListeners.removeAll()
    }
    
    func execCachedRequests() {
        cachedRequest.forEach({ (message, data, callback) in
            self.emit(message: message, data: data, callback: callback)
        })
        cachedRequest.removeAll()
    }
    
    func emit(message: String, data: Any, callback: Callback?) {
        if !isConnected {
            cachedRequest.append((message, data, callback))
        }
        else {
            if callback != nil {
                self.on(message: message, callback: callback, customId: nil, isOneTime: true)
            }
            if !currentRequests.contains(message) {
                if (callback != nil) {
                    currentRequests.append(message)
                }
                socket!.emit(message, with: [data])
            }
        }
    }

    func setup() {
        manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
        socket = manager!.socket(forNamespace: "/")
        
        socket!.on(clientEvent: .connect) {data, ack in
            self.isConnected = true
            self.execCachedListeners()
            self.execCachedRequests()
        }
        
        socket!.on(clientEvent: .disconnect) {data, ack in
            print("socket not connected")
        }
        
        socket!.connect()
    }
}
