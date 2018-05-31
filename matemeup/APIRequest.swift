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
    
    static func getInstance() -> APIRequest {
        if (instance == nil) {
            instance = APIRequest()
        }
        return instance!
    }
    
    func addQueryString(_ key: String, _ value: String) {
        queryStrings[key] = value
    }
    
    func send(route: String, method: String, body: Dictionary<String, Any>, callback: Callback)  {
        super.send(route: BASE_URL + route, method: method, queryString: self.queryStrings, body: body, callback: callback)
    }
    
}
