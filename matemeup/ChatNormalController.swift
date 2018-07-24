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
    @IBOutlet weak var notificationCount: UILabel!
    
    var currentUserId: Int? = nil
    var nextUserId: Int? = nil
    
    func setNextUserId(_ userId: Int?) {
        nextUserId = userId
    }
    
    func isNewUser() -> Bool {
        return currentUserId == nil || currentUserId != nextUserId
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userAvatar.image = nil
    }
    
}

class ChatNormalController : AChatListController {

    override func viewDidLoad() {
        isInvitation = false
        super.viewDidLoad()
        fetchList(requestUrl: "global.chat.user.normal.get", callback: { cell, user in
            let cncell = cell as! ChatNormalCell
            let count = user["unseen_messages_count"] as! Int
 
            cncell.setNextUserId(user["id"] as? Int)
            cncell.userName.text = user["name"] as? String
            cncell.userAvatar.contentMode = .scaleAspectFit
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
