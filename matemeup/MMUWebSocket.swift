//
//  MMUWebSocket.swift
//  matemeup
//
//  Created by Mehdi Meddour on 4/19/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import Foundation

class MMUWebSocket : WebSocket {
    private let URL: String = "http://192.168.1.21:8011"
    private let EHLO: String = "ehlo"
    private static var instance: MMUWebSocket? = nil
    private var isInit: Bool
    private var hasReceiveEhlo: Bool
    private var cachedEmits: [(String, Any, Callback?)]

    public static func getInstance() -> MMUWebSocket {
        if instance == nil {
        print("creating new instance")
         instance = MMUWebSocket()
        }
        return instance!
    }
    
    func execCachedRequestsEhlo() {
        print("executing cached requests ehlo")
        print(Unmanaged.passUnretained(self).toOpaque())
        cachedEmits.forEach({ (message, data, callback) in
            print("one")
            self.emit(message: message, data: data, callback: callback)
        })
        cachedEmits.removeAll()
    }
    
    override func emit(message: String, data: Any, callback: Callback?) {
        if (!hasReceiveEhlo && message != EHLO) {
            print("ehlo caching request "  + message)
            print(Unmanaged.passUnretained(self).toOpaque())
            cachedEmits.append((message, data, callback))
        }
        else {
            super.emit(message: message, data: data, callback: callback)
        }
    }
    
    private init() {
        hasReceiveEhlo = false
        isInit = false
        cachedEmits = []
        super.init(url: URL)
        if (!isInit) {
            let req: APIRequest = APIRequest.getInstance()
            
            isInit = true
            req.send(route: "matchmaker/token", method: "GET", body: [:], callback: Callback(
                success: { data in
                    let response = data as! [String: Any]
                    let token: String = response["token"] as! String
                    
                    self.emit(message: self.EHLO, data: token, callback: Callback(
                        success: { data in
                            if (self.hasReceiveEhlo == false) {
                                if ((data as! Array<Int>)[0] == 1) {
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
                    print("FAIL GETTING TOKEN MATCHMAKER")
                }
            ))
        }
    }
}
