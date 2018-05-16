//
//  RemoteImageLoader.swift
//  
//
//  Created by Mehdi Meddour on 3/26/18.
//

import UIKit

public class RemoteImageLoader {
    
    static func displayImage(_ view: UIImageView, _ data: Any) {
        print(data)
        DispatchQueue.main.async {
            view.image = UIImage(data: data as! Data)
             //view.sizeToFit()
        }
       
    }
    
    static func displayError(_ error: String) {
        print("Error loading image")
    }
    
    static func empty(view: UIImageView) {
        DispatchQueue.main.async {
            view.image = nil
        }
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
