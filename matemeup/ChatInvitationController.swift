//
//  ChatInvitationController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 4/19/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class ChatInvitationController : AChatListController {
    override func viewDidLoad() {
            super.viewDidLoad()
            fetchList(requestUrl: "global.chat.user.invitation.get", callback: { cell, user in
                let cncell = cell as! ChatNormalCell
                
                cncell.userName.text = user["name"] as? String
                Style.border(view: cncell.userAvatar)
                AvatarRemoteImageLoader.load(view: cncell.userAvatar, path: user["avatar"] as! String)
            })
        }
}
