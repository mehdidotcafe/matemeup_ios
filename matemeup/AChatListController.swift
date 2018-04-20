//
//  AChatListController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 4/19/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class AChatListController : UITableViewController {
    typealias ViewSetter = (UITableViewCell, String) -> Void
    var users: [String] = []
    var setter: ViewSetter? = nil
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userList", for: indexPath)
        self.setter!(cell, users[indexPath.row])
        return cell
    }
    
    func fetchList(requestUrl: String, callback: @escaping ViewSetter) {
        setter = callback
        MMUWebSocket.getInstance().emit(message: requestUrl, data: [:], callback: Callback(
            success: { data in
                let response = data as! [Any]
                
                response.forEach({ userRaw in
                    let user = (userRaw as! [[String: Any]])[0]
                    self.users.append(user["name"] as! String)
                    self.tableView.reloadData()
                })
            },
            fail: {data in print("FAIL GETTING USERS")}))
    }
}
