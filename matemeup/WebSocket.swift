//
//  WebSocket.swift
//  matemeup
//
//  Created by Mehdi Meddour on 4/17/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import SocketIO

//typealias SWebSocket = Starscream.WebSocket


class WebSocket {
    private let BASE_URL: String
    private var socket: SocketIOClient? = nil
    private var manager: SocketManager? = nil
    private var isConnected: Bool = false
    private var currentRequests: [String] = []
    private var cachedRequest: [(String, Any, Callback?)] = []
  
    init(url: String) {
        BASE_URL = url
    }
    
    func on(message: String, callback: Callback) {
        socket!.on(message) { data, ack in
            if (self.currentRequests.contains(message)) {
                self.currentRequests = self.currentRequests.filter() {$0 != message}
            }
            callback.success(data)
        }
    }
    
    func execCachedRequests() {
        cachedRequest.forEach({ (message, data, callback) in
            self.emit(message: message, data: data, callback: callback)
        })
        cachedRequest.removeAll()
    }
    
    func emit(message: String, data: Any, callback: Callback?) {
        if !isConnected {
            print("caching request " + message)
            cachedRequest.append((message, data, callback))
        }
        else {
            if callback != nil {
                self.on(message: message, callback: callback!)
            }
            if !currentRequests.contains(message) {
                currentRequests.append(message)
                print("emitting request " + message)
                socket!.emit(message, with: [data])
            }
        }
    }

    func setup() {
        manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
        socket = manager!.socket(forNamespace: "/")
        
        socket!.on(clientEvent: .connect) {data, ack in
            self.isConnected = true
            self.execCachedRequests()
            print("==== socket connected ====")
        }
        
        socket!.on(clientEvent: .disconnect) {data, ack in
            print("socket not connected")
        }
        
        socket!.connect()
    }
}
