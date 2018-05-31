//
//  RemoteImageLoader.swift
//  
//
//  Created by Mehdi Meddour on 3/26/18.
//

import UIKit

public class RemoteImageLoader {
    private static var cachedImage: [String: UIImage] = [:]
    
    
    static func displayImage(_ url: String, _ view: UIImageView, _ data: Any, _ callback: Callback?) {
        DispatchQueue.main.async {
            let image: UIImage? = UIImage(data: data as! Data)
            
            insertImageInView(view, image!)
            cachedImage[url] = image
            if callback != nil {
                callback!.success(view)
            }
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
    
    static func insertImageInView(_ view: UIImageView, _ image: UIImage) {
        view.image = image
    }
    
    static func load(view: UIImageView, base: String, path: String) -> URLSessionDataTask? {
        return load(view: view, base: base, path: path, callback: nil)
    }
    
    static func load(view: UIImageView, base: String, path: String, callback: Callback?)  -> URLSessionDataTask? {
        let req: ImageRequest = ImageRequest.getInstance()
        let url = base + (path.hasPrefix("/") ? path : "/" + path)
        
        if cachedImage[url] == nil {
            return req.getFile(route: url, queryString: [:], callback: Callback(
                success: {data in
                    self.displayImage(url, view, data, callback)
                },
                fail: {data in
                    if callback != nil {
                        callback!.fail("")
                    }
                }
            ))
        } else {
            insertImageInView(view, cachedImage[url]!)
            if callback != nil {
                callback!.success(view)
            }
            return nil
        }
    }
}
