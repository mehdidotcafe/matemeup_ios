//
//  FriendTableController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 5/6/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class FriendshipCell: UITableViewCell {
    var user: User? = nil
    var controller: FriendTableController? = nil
    
    func setUser(_ user: User) {
        self.user = user
    }
    
    func setController(_ controller: FriendTableController) {
        self.controller = controller
    }
    
}

class PendingTableCell: FriendshipCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBAction func acceptFriend(_ sender: Any) {
        if self.controller != nil {
            Alert.ok(controller: self.controller!, title: "L'utilisateur a été accepté", message: "", callback: Callback(
                success: {data in self.controller.self?.removePendingInList(self.user!)},
                fail: {data in}
            ))
            MMUWebSocket.getInstance().emit(message: "friend.accept", data: ["friendId": self.user!["id"] as! Int], callback: Callback(
                success: {data in },
                fail: {data in }
            ))
        }
    }
    
    @IBAction func refuseFriend(_ sender: Any) {
        if self.controller != nil {
            Alert.yesNo(controller: self.controller!, title: "Refuser " + (user!["name"] as! String) + " ?", message: "", callback: Callback(
                success: {data in self.controller.self?.removePending(self.user!)},
                fail: {data in }
            ))
        }
    }
}

class FriendTableCell : FriendshipCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    @IBAction func goToChat(_ sender: Any) {
        self.controller?.setUser(user!)
        Navigation.goTo(segue: "goToChatFromFriend", view: self.controller!)
    
    }
    
    @IBAction func deleteFriend(_ sender: Any) {
        if self.controller != nil {
            Alert.yesNo(controller: self.controller!, title: "Supprimer " + (user!["name"] as! String) + " ?", message: "", callback: Callback(
                success: {data in self.controller.self?.removeFriend(self.user!)},
                fail: {data in }
            ))
        }
    }
    
}

class FriendTableController : UITableViewController {
    typealias ViewSetter = (UICollectionViewCell, User) -> Void
    var friends: [User] = []
    var pendings: [User] = []
    var selectedUser: User? = nil
    
    func setUser(_ user: User) {
        selectedUser = user
    }
    
    func removePendingInList(_ user: User) {
        self.pendings = self.pendings.filter { pending in pending["id"] as! Int != user["id"] as! Int }
        self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
    
    func removePending(_ user: User) {
        removePendingInList(user)
        MMUWebSocket.getInstance().emit(message: "friend.refuse", data: [
            "friendId": user["id"]], callback: Callback(
                success: {data in}, fail: {data in}
        ))
    }
    
    func removeFriend(_ user: User) {
        self.friends = self.friends.filter { friend in friend["id"] as! Int != user["id"] as! Int }
        self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
        MMUWebSocket.getInstance().emit(message: "friend.refuse", data: [
            "friendId": user["id"]], callback: Callback(
                success: {data in}, fail: {data in}
        ))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChatFromFriend" {
            if let toViewController = segue.destination as? ChatContainerController {
                toViewController.setUser(self.selectedUser!)
            }
        } else if segue.identifier == "goToUserListFromFriendList" {
            if let toViewController = segue.destination as? UserSelectController {
                toViewController.setCallback(self.sendFriendRequest)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Vos demandes d'ami" : "Vos amis"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? pendings.count : friends.count
    }
    
    func sendFriendRequest(_ user: User) {
        MMUWebSocket.getInstance().emit(message: "friend.add", data: ["friendId": user["id"]], callback: Callback(
            success: {data in
                if (data as! [String: Any])["state"] as! Int == 0 {
                    Alert.ok(controller: self, title: "Erreur lors de l'envoi de la demande", message: "Vous êtes ami ou avait déjà envoyé une demande à " + (user["name"] as! String), callback: nil)
                } else {
                    Alert.ok(controller: self, title: "Demande envoyée", message: "La demande a été envoyée à " + (user["name"] as! String), callback: nil)}
            },
            fail: {data in Alert.ok(controller: self, title: "Erreur lors de l'envoi de la demande", message: "", callback: nil)}
            ))
    }
    
    func fillPendingCell(_ cell: PendingTableCell, _ pending: User) -> PendingTableCell {
        cell.setUser(pending)
        cell.setController(self)
        Style.border(view: cell.avatar)
        let _ = AvatarRemoteImageLoader.load(view: cell.avatar, path: pending["avatar"] as! String)
        cell.name.text = pending["name"] as? String
        
        return cell
    }
    
    func fillFriendCell(_ cell: FriendTableCell, _ friend: User) -> FriendTableCell {
        cell.setUser(friend)
        cell.setController(self)
        Style.border(view: cell.avatar)
        let _ = AvatarRemoteImageLoader.load(view: cell.avatar, path: friend["avatar"] as! String)
        cell.name.text = friend["name"] as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = nil

        cell = tableView.dequeueReusableCell(withIdentifier: indexPath.section == 0 ? "pendingCell" : "friendCell", for: indexPath)
        return indexPath.section == 0 ? fillPendingCell(cell as! PendingTableCell, pendings[indexPath.row]) : fillFriendCell(cell as! FriendTableCell, friends[indexPath.row])
    }
    
    func fetchList(requestFriendUrl: String, requestPendingUrl: String, callback: @escaping ViewSetter) {
        let socket: MMUWebSocket = MMUWebSocket.getInstance()
        
        socket.emit(message: requestFriendUrl, data: [:], callback: Callback(
            success: { data in
                let response = data as! [Any]
                
                response.forEach({ userRaw in
                    let user = userRaw as! [String: Any]
                    self.friends.append(["name": user["name"] as! String, "avatar": user["avatar"] as! String, "id": user["id"] as! Int])
                })
                self.tableView!.reloadData()
        },
            fail: {data in print("FAIL GETTING ACCEPTEDS")}))
        
        socket.emit(message: requestPendingUrl, data: [:], callback: Callback(
            success: { data in
                let response = data as! [Any]
                
                response.forEach({ userRaw in
                    let user = userRaw as! [String: Any]
                    self.pendings.append(["name": user["name"] as! String, "avatar": user["avatar"] as! String, "id": user["id"] as! Int])
                })
                self.tableView!.reloadData()
        },
            fail: {data in print("FAIL GETTING PENDINGS")}))
    }
    
    func addNewPending(_ user: User) {
        pendings.append(user)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: pendings.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    func addNewFriend(_ user: User) {
        friends.append(user)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: friends.count - 1, section: 1)], with: .automatic)
        tableView.endUpdates()
    }
    
    func setListeners() {
        let socket: MMUWebSocket = MMUWebSocket.getInstance()
        
        socket.on(message: "friend.add.new", callback: Callback(
            success: {data in
               self.addNewPending(data as! User)
        },
            fail: {data in print("fail")}
        ))
        
        socket.on(message: "friend.accept.new", callback: Callback(
            success: {data in
                print("IN FRIEND ACCEPT NEW")
                self.addNewFriend(data as! User)
        },
            fail: {data in print("fail")}
        ))
    }
    
    @objc private func goToUserList() {
        Navigation.goTo(segue: "goToUserListFromFriendList", view: self)
    }
    
    private func setNavbarButton() {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_add_white_24pt"), for: .normal)
        
        let barButton = UIBarButtonItem(customView: button)
        
        button.addTarget(self, action: #selector(self.goToUserList), for: .touchUpInside)
        self.tabBarController?.navigationItem.rightBarButtonItem = barButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavbarButton()
        fetchList(requestFriendUrl: "friend.accepted.get", requestPendingUrl: "friend.pending.get", callback: {view, user in })
        setListeners()
    }
    
}
