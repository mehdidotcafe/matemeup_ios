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
        isInvitation = true
        super.viewDidLoad()
        fetchList(requestUrl: "global.chat.user.invitation.get", callback: { cell, user in
            let cncell = cell as! ChatNormalCell
            let count = user["unseen_messages_count"] as! Int
            
            cncell.setNextUserId(user["id"] as? Int)
            cncell.userName.text = user["name"] as? String
            Style.border(view: cncell.userAvatar)
            if count > 0 {
                Style.rounded(view: cncell.notificationCount)
                cncell.notificationCount.text = String(count)
                cncell.notificationCount.isHidden = false
            } else {
                cncell.notificationCount.isHidden = true
            }
            Style.border(view: cncell.notificationCount)
            if cncell.isNewUser() {
                let _ = AvatarRemoteImageLoader.load(view: cncell.userAvatar, path: user["avatar"] as! String)
            }
        })
        setNewMessageListener()
    }
}
