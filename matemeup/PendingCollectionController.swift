//
//  PendingCollectionController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 5/6/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class PendingCell : UICollectionViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    
}

class PendingCollectionController : UICollectionViewController {
    typealias ViewSetter = (UICollectionViewCell, User) -> Void
    var pendings: [User] = []
    
    func fetchList(requestUrl: String, callback: @escaping ViewSetter) {
        MMUWebSocket.getInstance().emit(message: requestUrl, data: [:], callback: Callback(
            success: { data in
                let response = data as! [Any]

                response.forEach({ userRaw in
                    let user = userRaw as! [String: Any]
                    self.pendings.append(["name": user["name"] as! String, "avatar": user["avatar"] as! String, "id": user["id"] as! Int])
                })
                self.collectionView!.reloadData()
        },
            fail: {data in print("FAIL GETTING PENDINGS")}))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchList(requestUrl: "friend.pending.get", callback: {view, user in })
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pendings.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pendingFriend", for: indexPath)
        let pendingCell = cell as! PendingCell
        let user = pendings[indexPath.row]

        Style.border(view: pendingCell.avatar)
        pendingCell.name.text = user["name"] as? String
        AvatarRemoteImageLoader.load(view: pendingCell.avatar, path: user["avatar"] as! String)
        return pendingCell
    }
}
