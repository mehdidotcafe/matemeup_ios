//
//  ChatRemoteImageLoader.swift
//  matemeup
//
//  Created by Mehdi Meddour on 5/5/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class ChatRemoteImageLoader : RemoteImageLoader {
    private static let URL = Constants.chatImageUrl
    
    static func load(view: UIImageView, path: String) {
        return super.load(view: view, base: URL, path: path)
    }
    
}
