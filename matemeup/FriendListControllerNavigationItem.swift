//
//  FriendListControllerNavigationItem.swift
//  matemeup
//
//  Created by Mehdi Meddour on 6/4/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class FriendListControllerNavigationItem : UINavigationItem {
    override init(title: String) {
        super.init(title: title)
        print("BONJOUR")
    }
    
    override init(coder: NSCoder) {
        super.init(coder)
        print("BONJOUR2")
    }
}
