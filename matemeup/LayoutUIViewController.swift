//
//  LayoutUIViewController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 4/17/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class LayoutUIViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        //view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        //view.endEditing(true)

    }
}
