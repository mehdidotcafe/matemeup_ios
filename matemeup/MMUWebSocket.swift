//
//  MMUWebSocket.swift
//  matemeup
//
//  Created by Mehdi Meddour on 4/19/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import Foundation

class MMUWebSocket : WebSocket {
    private let URL: String = Constants.wsUrl
    private let EHLO: String = "ehlo"
    private static var instance: MMUWebSocket? = nil
    private var isInit: Bool = false
    private var hasReceiveEhlo: Bool
    private var cachedEmits: [(String, Any, Callback?)]
    
    public static func getInstance() -> MMUWebSocket {
        if instance == nil {
         instance = MMUWebSocket()
        } else if instance?.isInit == false {
            instance?.initSocket()
        }
        return instance!
    }
    
    public static func unset() {
        instance = nil
    }
    
    override func onReconnect() {
        print("IN RECONNECT")
        MMUWebSocket.instance?.initSocket()
    }
    
    override func onConnectError() {
        //MMUWebSocket.instance?.isInit = false
    }
    
    func execCachedRequestsEhlo() {
        cachedEmits.forEach({ (message, data, callback) in
            self.emit(message: message, data: data, callback: callback)
        })
        cachedEmits.removeAll()
    }
    
    override func emit(message: String, data: Any, callback: Callback?) {
        if (!hasReceiveEhlo && message != EHLO) {
            print("CACHING")
            cachedEmits.append((message, data, callback))
        }
        else {
            print("SENDING")
            super.emit(message: message, data: data, callback: callback)
        }
    }
    
    private func initSocket() {
        hasReceiveEhlo = false
        cachedEmits = []
            let req: APIRequest = APIRequest.getInstance()
            
            isInit = true
            let _ = req.send(route: "matchmaker/token", method: "GET", body: [:], callback: Callback(
                success: { data in
                    print("B")
                    let response = data as! [String: Any]
                    let token: String = response["token"] as! String
                    
                    print("C")
                    print(token)
                    self.emit(message: self.EHLO, data: token, callback: Callback(
                        success: { data in
                            print("D")
                            if (self.hasReceiveEhlo == false) {
                                if data as! Int == 1 {
                                    self.hasReceiveEhlo = true
                                    self.execCachedRequestsEhlo()
                                }
                            }
                    },
                        fail: {data in
                            print("FAIL EHLO")
                    }
                    ))
            },
                fail: {data in
                    self.onConnectError()
                    print("FAIL GETTING TOKEN MATCHMAKER")
            }
            ))
    }
    
    private init() {
        hasReceiveEhlo = false
        cachedEmits = []
        super.init(url: URL)
        initSocket()
    }
}
