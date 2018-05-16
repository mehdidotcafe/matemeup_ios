//
//  Style.swift
//  matemeup
//
//  Created by Mehdi Meddour on 5/6/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class Style {
    static func border(view: UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        rounded(view: view)
    }
    
    static func rounded(view: UIView) {
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
    }
    
    static func shadowAtPosition(view: UIView, width: Int, height: Int) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: width, height: height)
    }

    static func shadowTop(view: UIView) {
        shadowAtPosition(view: view, width: 0, height: -5)
    }
    
    static func shadowBot(view: UIView) {
        shadowAtPosition(view: view, width: 0, height: 5)
    }
}
