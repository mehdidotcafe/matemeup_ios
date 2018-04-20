//
//  NavbarLogoCenter.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/27/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class NavbarLogoCenter {
    static func displayLogo(_ navigationItem: UINavigationItem) {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo-margin.png"))
        let side = 2
        
        imageView.frame = CGRect(x: 0, y: 0, width: side, height: side)
        imageView.contentMode = .scaleAspectFit

        navigationItem.titleView = imageView
        navigationItem.titleView?.sizeToFit()
    }
}
