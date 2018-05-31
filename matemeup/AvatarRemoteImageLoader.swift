//
//  MMRemoteImageLoader.swift
//  
//
//  Created by Mehdi Meddour on 3/26/18.
//

import UIKit

class AvatarRemoteImageLoader : RemoteImageLoader {
    private static var BASE_URL: String = Constants.avatarUrl
    
    static func load(view: UIImageView, path: String) -> URLSessionDataTask? {
        return super.load(view: view, base: BASE_URL, path: path)
    }
}
