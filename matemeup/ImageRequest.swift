//
//  ImageRequest.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/27/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import Foundation

class ImageRequest: Request {
    private var BASE_URL: String = "https://www.matemeup.com/img/avatars"
    private static var instance: ImageRequest?
    private var queryStrings: Dictionary<String, String> = [:]
    
    static func getInstance() -> ImageRequest {
        if (instance == nil) {
            instance = ImageRequest()
        }
        return instance!
    }
    
    func addQueryString(_ key: String, _ value: String) {
        queryStrings[key] = value
    }
    
    func getFile(route: String, method: String, body: Dictionary<String, Any>, callback: Callback) -> URLSessionDataTask {
        return super.getFile(route: route, queryString: self.queryStrings, callback: callback)
    }
    
    func send(route: String, method: String, body: Dictionary<String, Any>, callback: Callback) -> URLSessionDataTask {
        return super.send(route: BASE_URL + route, method: method, queryString: self.queryStrings, body: body, callback: callback)
    }
    
}
