//
//  RemoteImageLoader.swift
//  
//
//  Created by Mehdi Meddour on 3/26/18.
//

import UIKit

public class RemoteImageLoader {
    
    static func displayImage(_ view: UIImageView, _ data: Any) {
        DispatchQueue.main.async {
            view.image = UIImage(data: data as! Data)
        }
    }
    
    static func displayError(_ error: String) {
        print("Error loading image")
    }
    
    static func load(view: UIImageView, base: String, path: String) {
        let req: ImageRequest = ImageRequest.getInstance()
        let url = base + (path.hasPrefix("/") ? path : "/" + path)
        
        req.getFile(route: url, queryString: [:], callback: Callback(
            success: {data in self.displayImage(view, data)},
            fail: self.displayError
        ))
    }
}
