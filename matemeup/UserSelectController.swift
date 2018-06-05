//
//  UserSelectController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 6/3/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
}

class UserListSelectHeader : UITableViewCell {
    @IBOutlet weak var input: UITextField!
}

class UserSelectController : UITableViewController, UITextFieldDelegate {
    var users: [User] = []
    var originUsers: [User] = []
    var callback: ((User) -> Void)? = nil
    var filter: String = ""
    var currentCall: URLSessionDataTask? = nil
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    @IBAction func filter(_ sender: UITextField) {
        if sender.text != nil {
            filterFromString(sender.text!)
        } else {
            filterFromString("")
        }
    }
    
    private func filterFromString(_ pattern: String) {
        self.filter = pattern
        fetchAndRender()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "userHeader") as! UserListSelectHeader
        
        header.input.delegate = self
        return header.contentView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        
        cell.username.text = user["name"] as? String
        let _ = AvatarRemoteImageLoader.load(view: cell.avatar, path: user["avatar"] as! String)
        cell.selectionStyle = .none
        Style.border(view: cell.avatar)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        self.dismiss(animated: true, completion: nil)
        if callback != nil {
            callback!(user)
        }
    }
    
    public func setCallback(_ cb: @escaping (User) -> Void) {
        callback = cb
    }
    
    private func unsetListeners() {
        
    }
    
    private func fetchAndRender() {
        currentCall?.cancel()
        currentCall = APIRequest.getInstance().send(route: "users/chat/get", method: "GET", queryString: ["needle": self.filter], body: [:], callback: Callback(
            success: {data in
                let dataObj = data as! [String: Any?]
                
                self.currentCall = nil
                self.users.removeAll()
                self.users = dataObj["users"] as! [User]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        },
            fail: {error in
                print("USER SELECT CONTROLLER ERROR")
                print(error)}
        ))
    }
    
    private func setListeners() {
        fetchAndRender()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsetListeners()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setListeners()
    }
}
