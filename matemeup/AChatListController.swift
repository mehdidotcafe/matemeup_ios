//
//  AChatListController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 4/19/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class AChatListController : UITableViewController, UITextFieldDelegate {
    typealias ViewSetter = (UITableViewCell, User) -> Void
    var originUsers: [User] = []
    var filteredUsersIdx: [Int] = []
    var setter: ViewSetter? = nil
    var pattern: String = ""
    var isInvitation: Bool = false
    
    func getUserFromId(_ id: Int) -> User {
        return originUsers[getOriginUserIndexFromId(id)]
    }
    
    func getOriginUserIndexFromId(_ id: Int) -> Int {
        var index = 0
        
        for _ in originUsers {
            if originUsers[index]["id"] as! Int == id {
                return index
            }
            index += 1
        }
        return -1
    }
    
    func getFilteredUserIndexFromId(_ id: Int) -> Int {
        let index: Int = getOriginUserIndexFromId(id)
        var ret: Int = 0
        
        if index != -1 {
            for userIdx in filteredUsersIdx {
                if userIdx == index {
                    return ret
                }
                ret += 1
            }
        }
        return -1
    }
    
    func incrUserUseenMessageCount(_ userId: Int) {
        let fIndex = getFilteredUserIndexFromId(userId)
        let oIndex = getOriginUserIndexFromId(userId)
	
        if oIndex != -1 {
            originUsers[oIndex]["unseen_messages_count"] = (originUsers[oIndex]["unseen_messages_count"] as! Int) + 1
        }

        if fIndex != -1 {
            self.tableView.reloadRows(at: [IndexPath(item: fIndex, section: 0)], with: .none)
        }
    }
    
    func deleteUserFromList(_ userId: Int) {
        originUsers = originUsers.filter{$0["id"] as! Int != userId}
        filterFromPattern(pattern)
        
    }
    
    func appendOriginUser(_ user: User) {
        var nuser = user
        
        if nuser["unseen_messages_count"] == nil {
            nuser["unseen_messages_count"] = 0
        }
        originUsers.append(nuser)
    }
    
    func onNewMessage(_ data: Any) {
        let dataArray = data as! [String: Any]
        let _: NewMessageNotifier = dataArray["instance"] as! NewMessageNotifier
        let user: User = dataArray["user"] as! User
        let userId = user["id"] as! Int
        let message: Message = dataArray["lastMessage"] as! Message
        let msgIsInvatation = message["isInvitation"] as! Int
 
        if message["isUser"] as! Int == 0 {
            if (msgIsInvatation == 1) != isInvitation {
                deleteUserFromList(userId)
            } else {
                if getOriginUserIndexFromId(userId) == -1 {
                    appendOriginUser(user)
                    filterFromPattern(pattern)
                }
                incrUserUseenMessageCount(userId)
            }
        }
    }
    
    func onNewConnectedMessage(_ data: Any) {
        let dataArray = data as! [String: Any]
        let _: NewMessageNotifier = dataArray["instance"] as! NewMessageNotifier
        let user: User = dataArray["user"] as! User
        let userId = user["id"] as! Int
        let message: Message = dataArray["lastMessage"] as! Message
        let msgIsInvatation = message["isInvitation"] as! Int
        
        print("DANS ON NEW CONNECTED MESSAGE")
        if (msgIsInvatation == 1) != isInvitation {
         deleteUserFromList(userId)
        } else if getOriginUserIndexFromId(userId) == -1 {
            appendOriginUser(user)
            filterFromPattern(pattern)            
        }
    }
    
    func onDelUser(_ data: Any) {
        let dataArray = data as! [String: Any]
        let user = dataArray["user"] as! User
        let userId = user["id"] as! Int
        let oIndex = getOriginUserIndexFromId(userId)
        let fIndex = getFilteredUserIndexFromId(userId)
        
        if oIndex != -1 {
            originUsers[oIndex]["unseen_messages_count"] = 0
            self.tableView.reloadRows(at: [IndexPath(item: fIndex, section: 0)], with: .none)
        }	
    }
    
    func setNewMessageListener() {
        let notifier: NewMessageNotifier = NewMessageNotifier.getInstance()
        
        notifier.on(message: "newUserMessage", callback: Callback(
            success: {data in self.onNewMessage(data)},
            fail: {data in print("FAIL")}
        ))
        notifier.on(message: "newConnectedMessage", callback: Callback(
            success: {data in self.onNewConnectedMessage(data)},
            fail: {data in print("FAIL")}
        ))
        notifier.on(message: "delUser", callback: Callback(
            success: {data in self.onDelUser(data)},
            fail: {data in print("FAIL")}
        ))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //print("in number of sections")
        //if originUsers.count > 0 {
            return 1
        //} else {
        //    TableViewHelper.EmptyMessage(message: "Vous n'avez pas de discussions.", viewController: self)
        //    return 0
        //}
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsersIdx.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userList", for: indexPath)
        cell.selectionStyle = .none
        self.setter!(cell, originUsers[filteredUsersIdx[indexPath.row]])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = originUsers[filteredUsersIdx[indexPath.row]]
        
        (self.parent as! ChatListController).setUser(user)
        (self.parent as! ChatListController).setIsInvitation(isInvitation)
        Navigation.goTo(segue: "goToChat", view: self.parent!)
    }
    
    func filterFromPattern(_ pattern: String) {
        var idx = 0
        
        filteredUsersIdx.removeAll()
        originUsers.forEach { user in
            let name = user["name"] as! String
            
            if pattern == "" || name.lowercased().range(of:pattern) != nil {
                filteredUsersIdx.append(idx)
            }
            idx += 1
        }
        self.tableView.reloadData()
    }
    
    @objc func filter(_ notification: NSNotification) {
        let pattern = notification.userInfo?["pattern"] as? String
        
        filterFromPattern(pattern == nil ? "" : pattern!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(filter), name: NSNotification.Name(rawValue: "chatListFilter"), object: nil)
    }
    
    func fetchList(requestUrl: String, callback: @escaping ViewSetter) {
        setter = callback
        MMUWebSocket.getInstance().emit(message: requestUrl, data: [:], callback: Callback(
            success: { data in
                let response = data as! [Any]
                var index = 0
                
                response.forEach({ userRaw in
                    let user = userRaw as! [String: Any]
                    self.originUsers.append(["name": user["name"] as! String, "avatar": user["avatar"] as! String, "id": user["id"] as! Int, "unseen_messages_count": user["unseen_messages_count"] as! Int])
                    self.filteredUsersIdx.append(index)
                    index += 1
                })
                self.filterFromPattern("")
                NewMessageNotifier.getInstance().setUsers(self.originUsers)
            },
            fail: {data in print("FAIL GETTING USERS")}))
    }
}
