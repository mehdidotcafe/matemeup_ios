//
//  MMRemoteImageLoader.swift
//  
//
//  Created by Mehdi Meddour on 3/26/18.
//

import UIKit

class AvatarRemoteImageLoader : RemoteImageLoader {
    private static var BASE_URL: String = "https://www.matemeup.com/img/avatars"
    
    static func load(view: UIImageView, path: String) {
        return super.load(view: view, base: BASE_URL, path: path)
    }
}
