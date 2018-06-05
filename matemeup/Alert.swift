//
//  Alert.swift
//  matemeup
//
//  Created by Mehdi Meddour on 5/16/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class Alert {
    public static func ok(controller: UIViewController, title: String, message: String, callback: Callback?) {
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)

        refreshAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
            callback?.success(action)
        }))
        
        controller.present(refreshAlert, animated: true, completion: nil)
    }
    
    public static func yesNo(controller: UIViewController, title: String, message: String, callback: Callback?) {
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "NON", style: .default, handler: { (action: UIAlertAction!) in
            callback?.fail("")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "OUI", style: .cancel, handler: { (action: UIAlertAction!) in
            callback?.success(action)
        }))
        
        controller.present(refreshAlert, animated: true, completion: nil)
    }
}
