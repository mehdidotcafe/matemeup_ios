//
//  ChatNormalController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 4/19/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class ChatNormalCell : UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
}

class ChatNormalController : AChatListController {
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchList(requestUrl: "global.chat.user.normal.get", callback: { cell, user in
            let cncell = cell as! ChatNormalCell
            
            cncell.userName.text = user
        })
    }
}
