//
//  Navbar.swift
//  matemeup
//
//  Created by Mehdi Meddour on 5/14/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class Navbar {
    static func view(_ navigationItem: UINavigationItem, _ view: UIView) {
        navigationItem.titleView = view
    }
    
    static func logo(_ navigationItem: UINavigationItem) {
        let logo = UIImage(named: "logo-margin.png")
        let imageView = UIImageView(image:logo)
        
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
}
