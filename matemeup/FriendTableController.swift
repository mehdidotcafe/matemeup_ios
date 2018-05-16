//
//  FriendTableController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 5/6/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class FriendTableCell : UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    var user: User? = nil
    var controller: FriendTableController? = nil

    
    @IBAction func filter(_ sender: Any) {
        print("CA FILTRE")
    }
    
    @IBAction func goToChat(_ sender: Any) {
        self.controller?.setUser(user!)
        Navigation.goTo(segue: "goToChatFromFriend", view: self.controller!)
    
    }
    
    @IBAction func deleteFriend(_ sender: Any) {
        let refreshAlert = UIAlertController(title: user!["name"] as? String, message: "Supprimer ?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "NON", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "OUI", style: .cancel, handler: { (action: UIAlertAction!) in
            self.controller?.removeUser(self.user!)
        }))
        
        controller?.present(refreshAlert, animated: true, completion: nil)
    }
    
    func setUser(_ user: User) {
        self.user = user
    }
    
    func setController(_ controller: FriendTableController) {
        self.controller = controller
    }
    
}

class FriendTableController : UITableViewController {
    typealias ViewSetter = (UICollectionViewCell, User) -> Void
    var friends: [User] = []
    var selectedUser: User? = nil
    
    func setUser(_ user: User) {
        selectedUser = user
    }
    
    func removeUser(_ user: User) {
        MMUWebSocket.getInstance().emit(message: "friend.refuse", data: [
            "friendId": user["id"]], callback: Callback(
                success: {data in
                    self.friends = self.friends.filter { friend in friend["id"] as! Int != user["id"] as! Int }
                    self.tableView.reloadData()
            }, fail: {data in}
        ))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChatFromFriend" {
            if let toViewController = segue.destination as? ChatContainerController {
                toViewController.setUser(self.selectedUser!)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell : UITableViewCell? = nil
//
//        cell = tableView.dequeueReusableCell(withIdentifier: indexPath.section == 1 ? "friendCell" : "pendingCell", for: indexPath)
//        let ccell = cell as! FriendTableCell
//            let friend = friends[indexPath.row]
//        
//            ccell.setUser(friend)
//            ccell.setController(self)
//            Style.border(view: ccell.avatar)
//            AvatarRemoteImageLoader.load(view: ccell.avatar, path: friend["avatar"] as! String)
//            ccell.name.text = friend["name"] as? String
//        print("JE RET UNE CELL")
//        return cell!
//    }
    
    func fetchList(requestUrl: String, callback: @escaping ViewSetter) {
        MMUWebSocket.getInstance().emit(message: requestUrl, data: [:], callback: Callback(
            success: { data in
                let response = data as! [Any]
                
                response.forEach({ userRaw in
                    let user = userRaw as! [String: Any]
                    self.friends.append(["name": user["name"] as! String, "avatar": user["avatar"] as! String, "id": user["id"] as! Int])
                })
                self.tableView!.reloadData()
        },
            fail: {data in print("FAIL GETTING ACCEPTEDS")}))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchList(requestUrl: "friend.accepted.get", callback: {view, user in })
    }
    
}
