//
//  APIRequest.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/27/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import Foundation

class APIRequest: Request {
    private var BASE_URL: String = Constants.apiUrl
    private static var instance: APIRequest?
    private var queryStrings: Dictionary<String, String> = [:]
    
    public func unsetQueryString() {
        self.queryStrings = [:]
    }

    static func getInstance() -> APIRequest {
        if (instance == nil) {
            instance = APIRequest()
        }
        return instance!
    }
    
    func addQueryString(_ key: String, _ value: String) {
        queryStrings[key] = value
    }

    override func send(route: String, method: String, queryString: Dictionary<String, String>, body: Dictionary<String, Any>, callback: Callback) -> URLSessionDataTask {
        var qs = self.queryStrings
        
        queryString.forEach{(k, v) in
            qs[k] = v
        }
        return super.send(route: BASE_URL + route, method: method, queryString: qs, body: body, callback: callback)
    }
    
    func send(route: String, method: String, body: Dictionary<String, Any>, callback: Callback) -> URLSessionDataTask {
        return super.send(route: BASE_URL + route, method: method, queryString: self.queryStrings, body: body, callback: callback)
    }
    
}
